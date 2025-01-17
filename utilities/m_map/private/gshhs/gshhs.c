/*	$Id: gshhs.c,v 1.18 2008/01/23 03:22:49 guru Exp $
 *
 *	Copyright (c) 1996-2008 by P. Wessel and W. H. F. Smith
 *	See COPYING file for copying and redistribution conditions.
 *
 * PROGRAM:	gshhs.c
 * AUTHOR:	Paul Wessel (pwessel@hawaii.edu)
 * CREATED:	JAN. 28, 1996
 * PURPOSE:	To extract ASCII data from binary shoreline data
 *		as described in the 1996 Wessel & Smith JGR Data Analysis Note.
 * VERSION:	1.1 (Byte flipping added)
 *		1.2 18-MAY-1999:
 *		   Explicit binary open for DOS systems
 *		   POSIX.1 compliant
 *		1.3 08-NOV-1999: Released under GNU GPL
 *		1.4 05-SEPT-2000: Made a GMT supplement; FLIP no longer needed
 *		1.5 14-SEPT-2004: Updated to deal with latest GSHHS database (1.3)
 *		1.6 02-MAY-2006: Updated to deal with latest GSHHS database (1.4)
 *		1.7 11-NOV-2006: Fixed bug in computing level (&& vs &)
 *		1.8 31-MAR-2007: Updated to deal with latest GSHHS database (1.5)
 *		1.9 27-AUG-2007: Handle line data as well as polygon data
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; version 2 of the License.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	Contact info: www.soest.hawaii.edu/pwessel */

#include "gshhs.h"

int main (int argc, char **argv)
{
	double w, e, s, n, area, lon, lat;
	char source, kind[2] = {'P', 'L'}, *name[2] = {"polygon", "line"};
	FILE	*fp;
	int	k, line, max_east = 270000000, info, n_read, flip, level, version, greenwich, src;
	struct	POINT p;
	struct GSHHS h;
        
	if (argc < 2 || argc > 3) {
		fprintf (stderr, "gshhs v. %s ASCII export tool\n", GSHHS_PROG_VERSION);
		fprintf (stderr, "usage:  gshhs gshhs_[f|h|i|l|c].b [-L] > ascii.dat\n");
		fprintf (stderr, "-L will only list headers (no data output)\n");
		exit (EXIT_FAILURE);
	}

	info = (argc == 3);
	if ((fp = fopen (argv[1], "rb")) == NULL ) {
		fprintf (stderr, "gshhs:  Could not find file %s.\n", argv[1]);
		exit (EXIT_FAILURE);
	}
		
	n_read = fread ((void *)&h, (size_t)sizeof (struct GSHHS), (size_t)1, fp);
	version = (h.flag >> 8) & 255;
	flip = (version != GSHHS_DATA_VERSION);	/* Take as sign that byte-swabbing is needed */
	
	while (n_read == 1) {
		if (flip) {
			h.id = swabi4 ((unsigned int)h.id);
			h.n  = swabi4 ((unsigned int)h.n);
			h.west  = swabi4 ((unsigned int)h.west);
			h.east  = swabi4 ((unsigned int)h.east);
			h.south = swabi4 ((unsigned int)h.south);
			h.north = swabi4 ((unsigned int)h.north);
			h.area  = swabi4 ((unsigned int)h.area);
			h.flag  = swabi4 ((unsigned int)h.flag);
		}
		level = h.flag & 255;
		version = (h.flag >> 8) & 255;
		greenwich = (h.flag >> 16) & 255;
		src = (h.flag >> 24) & 255;
		w = h.west  * GSHHS_SCL;	/* Convert from microdegrees to degrees */
		e = h.east  * GSHHS_SCL;
		s = h.south * GSHHS_SCL;
		n = h.north * GSHHS_SCL;
		source = (src == 1) ? 'W' : 'C';	/* Either WVS or CIA (WDBII) pedigree */
		line = (h.area) ? 0 : 1;		/* Either Polygon (0) or Line (1) (if no area) */
		area = 0.1 * h.area;			/* Now im km^2 */

		printf ("%c %6d%8d%2d%2c%13.3f%10.5f%10.5f%10.5f%10.5f\n", kind[line], h.id, h.n, level, source, area, w, e, s, n);

		if (info) {	/* Skip data, only want headers */
			fseek (fp, (long)(h.n * sizeof(struct POINT)), SEEK_CUR);
		}
		else {
			for (k = 0; k < h.n; k++) {

				if (fread ((void *)&p, (size_t)sizeof(struct POINT), (size_t)1, fp) != 1) {
					fprintf (stderr, "gshhs:  Error reading file %s for %s %d, point %d.\n", argv[1], name[line], h.id, k);
					exit (EXIT_FAILURE);
				}
				if (flip) {
					p.x = swabi4 ((unsigned int)p.x);
					p.y = swabi4 ((unsigned int)p.y);
				}
				lon = p.x * GSHHS_SCL;
				if (greenwich && p.x > max_east) lon -= 360.0;
				lat = p.y * GSHHS_SCL;
				printf ("%10.5f%10.5f\n", lon, lat);
			}
		}
		max_east = 180000000;	/* Only Eurasiafrica needs 270 */
		n_read = fread((void *)&h, (size_t)sizeof (struct GSHHS), (size_t)1, fp);
	}
		
	fclose (fp);

	exit (EXIT_SUCCESS);
}
