#ifndef  _CDI_H
#define  _CDI_H

#include <sys/types.h>

#if defined(__cplusplus)
extern "C" {
#endif

#define  CDI_UNDEFID             -1

/* Byte order */

#define  CDI_BIGENDIAN            0   /* Byte order BIGENDIAN     */
#define  CDI_LITTLEENDIAN         1   /* Byte order LITTLEENDIAN  */

/* Error identifier */

#define  CDI_ESYSTEM            -10   /* Operating system error           */
#define  CDI_EINVAL             -20   /* Invalid argument                 */
#define  CDI_EUFTYPE            -21   /* Unsupported file type            */
#define  CDI_ELIBNAVAIL         -22   /* xxx library not available        */
#define  CDI_EUFSTRUCT          -23   /* Unsupported file structure       */

/* File types */

#define  FILETYPE_GRB             1   /* File type GRIB                   */
#define  FILETYPE_G2              2   /* File type GRIB version 2         */
#define  FILETYPE_NC              3   /* File type netCDF                 */
#define  FILETYPE_NC2             4   /* File type netCDF version 2       */
#define  FILETYPE_SRV             5   /* File type SERVICE                */
#define  FILETYPE_EXT             6   /* File type EXTRA                  */
#define  FILETYPE_IEG             8   /* File type IEG                    */

/* Compress types */

#define  COMPRESS_SZIP            1
#define  COMPRESS_GZIP            2
#define  COMPRESS_BZIP2           3

/* Data types */

#define  DATATYPE_PACK            0
#define  DATATYPE_PACK1           1
#define  DATATYPE_PACK2           2
#define  DATATYPE_PACK3           3
#define  DATATYPE_PACK4           4
#define  DATATYPE_PACK5           5
#define  DATATYPE_PACK6           6
#define  DATATYPE_PACK7           7
#define  DATATYPE_PACK8           8
#define  DATATYPE_PACK9           9
#define  DATATYPE_PACK10         10
#define  DATATYPE_PACK11         11
#define  DATATYPE_PACK12         12
#define  DATATYPE_PACK13         13
#define  DATATYPE_PACK14         14
#define  DATATYPE_PACK15         15
#define  DATATYPE_PACK16         16
#define  DATATYPE_PACK17         17
#define  DATATYPE_PACK18         18
#define  DATATYPE_PACK19         19
#define  DATATYPE_PACK20         20
#define  DATATYPE_PACK21         21
#define  DATATYPE_PACK22         22
#define  DATATYPE_PACK23         23
#define  DATATYPE_PACK24         24
#define  DATATYPE_PACK25         25
#define  DATATYPE_PACK26         26
#define  DATATYPE_PACK27         27
#define  DATATYPE_PACK28         28
#define  DATATYPE_PACK29         29
#define  DATATYPE_PACK30         30
#define  DATATYPE_PACK31         31
#define  DATATYPE_PACK32         32
#define  DATATYPE_FLT32         132
#define  DATATYPE_FLT64         164
#define  DATATYPE_INT8          208
#define  DATATYPE_INT16         216
#define  DATATYPE_INT32         232

/* GRID types */

#define  GRID_GENERIC             1
#define  GRID_GAUSSIAN            2
#define  GRID_GAUSSIAN_REDUCED    3
#define  GRID_LONLAT              4
#define  GRID_SPECTRAL            5
#define  GRID_FOURIER             6
#define  GRID_GME                 7  /* Icosahedral-hexagonal GME Grid */
#define  GRID_TRAJECTORY          8
#define  GRID_CELL                9
#define  GRID_CURVILINEAR        10

/* ZAXIS types */

#define  ZAXIS_SURFACE            0
#define  ZAXIS_GENERIC            1
#define  ZAXIS_HYBRID             2
#define  ZAXIS_HYBRID_HALF        3
#define  ZAXIS_PRESSURE           4
#define  ZAXIS_HEIGHT             5
#define  ZAXIS_DEPTH_BELOW_SEA    6
#define  ZAXIS_DEPTH_BELOW_LAND   7
#define  ZAXIS_ISENTROPIC         8
#define  ZAXIS_TRAJECTORY         9
#define  ZAXIS_ALTITUDE          10
#define  ZAXIS_SIGMA             11

/* TAXIS types */

#define  TAXIS_ABSOLUTE           1
#define  TAXIS_RELATIVE           2

/* TIME types */

#define  TIME_CONSTANT            1
#define  TIME_VARIABLE            2

/* TUNIT types */

#define  TUNIT_SECOND             1
#define  TUNIT_MINUTE             2
#define  TUNIT_HOUR               3
#define  TUNIT_DAY                4
#define  TUNIT_MONTH              5
#define  TUNIT_YEAR               6

/* CALENDAR types */

#define  CALENDAR_STANDARD        0
#define  CALENDAR_NONE            1
#define  CALENDAR_360DAYS         2
#define  CALENDAR_365DAYS         3
#define  CALENDAR_366DAYS         4
#define  CALENDAR_PROLEPTIC       5


/* CDI control routines */

char   *cdiStringError(int cdiErrno);

void    cdiDebug(int debug);

char   *cdiLibraryVersion(void);
void    cdiPrintVersion(void);

void    cdiDefMissval(double missval);
double  cdiInqMissval(void);
int     cdiDefGlobal(const char *string, int val);
void    cdiDefCompress(int type, int level);

/* STREAM control routines */

/*      streamOpenRead: Open a dataset for reading */
int     streamOpenRead(const char *path);

/*      streamOpenWrite: Create a new dataset */
int     streamOpenWrite(const char *path, int filetype);

int     streamOpenAppend(const char *path);

/*      streamClose: Close an open dataset */
void    streamClose(int streamID);

/*      streamDefVlist: Define the Vlist for a stream */
void    streamDefVlist(int streamID, int vlistID);

/*      streamInqVlist: Get the Vlist of a stream */
int     streamInqVlist(int streamID);

/*      streamInqFiletype: Get the filetype */
int     streamInqFiletype(int streamID);

/*      streamDefByteorder: Define the byteorder */
void    streamDefByteorder(int streamID, int byteorder);

/*      streamInqByteorder: Get the byteorder */
int     streamInqByteorder(int streamID);

/*      streamDefTimestep: Define time step */
int     streamDefTimestep(int streamID, int tsID);

/*      streamInqTimestep: Get time step */
int     streamInqTimestep(int streamID, int tsID);

char   *streamFilename(int streamID);
char   *streamFilesuffix(int filetype);
int     streamNtsteps(int streamID);
off_t   streamNvals(int streamID);


/* STREAM var I/O routines */

/*      streamReadVar: Read a variable */
void    streamReadVar(int streamID, int varID, double *data, int *nmiss);

/*      streamWriteVar: Write a variable */
void    streamWriteVar(int streamID, int varID, double *data, int nmiss);

/*      streamReadVarSlice: Read a horizontal slice of a variable */
void    streamReadVarSlice(int streamID, int varID, int levelID, double *data, int *nmiss);

/*      streamWriteVarSlice: Write a horizontal slice of a variable */
void    streamWriteVarSlice(int streamID, int varID, int levelID, double *data, int nmiss);


/* STREAM record I/O routines */

void    streamInqRecord(int streamID, int *varID, int *levelID);
void    streamDefRecord(int streamID, int  varID, int  levelID);
void    streamReadRecord(int streamID, double *data, int *nmiss);
void    streamWriteRecord(int streamID, double *data, int nmiss);
void    streamCopyRecord(int streamIDdest, int streamIDsrc);

void    streamInqGinfo(int streamID, int *intnum, float *fltnum);

/* VLIST routines */

/*      vlistCreate: Create a variable list */
int     vlistCreate(void);

/*      vlistDestroy: Destroy a variable list */
void    vlistDestroy(int vlistID);

/*      vlistDuplicate: Duplicate a variable list */
int     vlistDuplicate(int vlistID);

/*      vlistCopy: Copy a variable list */
void    vlistCopy(int vlistID2, int vlistID1);

/*      vlistCopyFlag: Copy some entries of a variable list */
void    vlistCopyFlag(int vlistID2, int vlistID1);

void    vlistClearFlag(int vlistID);

/*      vlistCat: Concatenate two variable lists */
void    vlistCat(int vlistID2, int vlistID1);

/*      vlistMerge: Merge two variable lists */
void    vlistMerge(int vlistID2, int vlistID1);

void    vlistPrint(int vlistID);

/*      vlistNvars: Number of variables in a variable list */
int     vlistNvars(int vlistID);

/*      vlistNgrids: Number of grids in a variable list */
int     vlistNgrids(int vlistID);

/*      vlistNzaxis: Number of zaxis in a variable list */
int     vlistNzaxis(int vlistID);

void    vlistDefNtsteps(int vlistID, int nts);
int     vlistNtsteps(int vlistID);
int     vlistGridsizeMax(int vlistID);
int     vlistGrid(int vlistID, int index);
int     vlistGridIndex(int vlistID, int gridID);
void    vlistChangeGridIndex(int vlistID, int index, int gridID);
void    vlistChangeGrid(int vlistID, int gridID1, int gridID2);
int     vlistZaxis(int vlistID, int index);
int     vlistZaxisIndex(int vlistID, int zaxisID);
void    vlistChangeZaxisIndex(int vlistID, int index, int zaxisID);
void    vlistChangeZaxis(int vlistID, int zaxisID1, int zaxisID2);
int     vlistNrecs(int vlistID);

/*      vlistDefTaxis: Define the time axis of a variable list */
void    vlistDefTaxis(int vlistID, int taxisID);

/*      vlistInqTaxis: Get the time axis of a variable list */
int     vlistInqTaxis(int vlistID);

void    vlistDefTable(int vlistID, int tableID);
int     vlistInqTable(int vlistID);
void    vlistDefInstitut(int vlistID, int instID);
int     vlistInqInstitut(int vlistID);
void    vlistDefModel(int vlistID, int modelID);
int     vlistInqModel(int vlistID);
void    vlistDefAttribute(int vlistID, const char *attname, const char *attstring);


/* VLIST VAR routines */

/*      vlistDefVar: Create a new Variable */
int     vlistDefVar(int vlistID, int gridID, int zaxisID, int timeID);

void    vlistChangeVarGrid(int vlistID, int varID, int gridID);
void    vlistChangeVarZaxis(int vlistID, int varID, int zaxisID);

void    vlistInqVar(int vlistID, int varID, int *gridID, int *zaxisID, int *timeID);
int     vlistInqVarGrid(int vlistID, int varID);
int     vlistInqVarZaxis(int vlistID, int varID);
int     vlistInqVarTime(int vlistID, int varID);

void    vlistDefVarSzip(int vlistID, int varID, int szip);
int     vlistInqVarSzip(int vlistID, int varID);

/*      vlistDefVarCode: Define the code number of a Variable */
void    vlistDefVarCode(int vlistID, int varID, int code);

/*      vlistInqVarCode: Get the code number of a Variable */
int     vlistInqVarCode(int vlistID, int varID);

/*      vlistDefVarDatatype: Define the data type of a Variable */
void    vlistDefVarDatatype(int vlistID, int varID, int datatype);

/*      vlistInqVarDatatype: Get the data type of a Variable */
int     vlistInqVarDatatype(int vlistID, int varID);

void    vlistDefVarInstitut(int vlistID, int varID, int instID);
int     vlistInqVarInstitut(int vlistID, int varID);
void    vlistDefVarModel(int vlistID, int varID, int modelID);
int     vlistInqVarModel(int vlistID, int varID);
void    vlistDefVarTable(int vlistID, int varID, int tableID);
int     vlistInqVarTable(int vlistID, int varID);

/*      vlistDefVarName: Define the name of a Variable */
void    vlistDefVarName(int vlistID, int varID, const char *name);

/*      vlistInqVarName: Get the name of a Variable */
void    vlistInqVarName(int vlistID, int varID, char *name);

/*      vlistDefVarLongname: Define the long name of a Variable */
void    vlistDefVarLongname(int vlistID, int varID, const char *longname);

void    vlistDefVarStdname(int vlistID, int varID, const char *stdname);

/*      vlistInqVarLongname: Get the long name of a Variable */
void    vlistInqVarLongname(int vlistID, int varID, char *longname);

void    vlistInqVarStdname(int vlistID, int varID, char *stdname);

/*      vlistDefVarUnits: Define the units of a Variable */
void    vlistDefVarUnits(int vlistID, int varID, const char *units);

/*      vlistInqVarUnits: Get the units of a Variable */
void    vlistInqVarUnits(int vlistID, int varID, char *units);

/*      vlistDefVarMissval: Define the missing value of a Variable */
void    vlistDefVarMissval(int vlistID, int varID, double missval);

/*      vlistInqVarMissval: Get the missing value of a Variable */
double  vlistInqVarMissval(int vlistID, int varID);

void    vlistDefVarScalefactor(int vlistID, int varID, double scalefactor);
double  vlistInqVarScalefactor(int vlistID, int varID);
void    vlistDefVarAddoffset(int vlistID, int varID, double addoffset);
double  vlistInqVarAddoffset(int vlistID, int varID);
void    vlistDefVarAverage(int vlistID, int varID, int average);
int     vlistInqVarAverage(int vlistID, int varID);
int     vlistInqVarSize(int vlistID, int varID);
int     vlistInqVarID(int vlistID, int code);

void    vlistDefIndex(int vlistID, int varID, int levID, int index);
int     vlistInqIndex(int vlistID, int varID, int levID);
void    vlistDefFlag(int vlistID, int varID, int levID, int flag);
int     vlistInqFlag(int vlistID, int varID, int levID);
int     vlistFlagVar(int vlistID, int varID);
int     vlistFlagLevel(int vlistID, int varID, int levelID);
int     vlistFindVar(int vlistID, int fvarID);
int     vlistFindLevel(int vlistID, int fvarID, int flevelID);


/* GRID routines */

void    gridName(int gridtype, char *gridname);
char   *gridNamePtr(int gridtype);

void    gridCompress(int gridID);

void    gridDefMask(int gridID, int *mask);
int     gridInqMask(int gridID, int *mask);

void    gridPrint(int gridID, int opt);
int     gridSize(void);

/*      gridCreate: Create a horizontal Grid */
int     gridCreate(int gridtype, int size);

/*      gridDestroy: Destroy a horizontal Grid */
void    gridDestroy(int gridID);

/*      gridDuplicate: Duplicate a Grid */
int     gridDuplicate(int gridID);

/*      gridInqType: Get the type of a Grid */
int     gridInqType(int gridID);

/*      gridInqSize: Get the size of a Grid */
int     gridInqSize(int gridID);

/*      gridDefXsize: Define the size of a X-axis */
void    gridDefXsize(int gridID, int xsize);

/*      gridInqXsize: Get the size of a X-axis */
int     gridInqXsize(int gridID);

/*      gridDefYsize: Define the size of a Y-axis */
void    gridDefYsize(int gridID, int ysize);

/*      gridInqYsize: Get the size of a Y-axis */
int     gridInqYsize(int gridID);

/*      gridDefXvals: Define the values of a X-axis */
void    gridDefXvals(int gridID, double *xvals);

/*      gridInqXvals: Get all values of a X-axis */
int     gridInqXvals(int gridID, double *xvals);

/*      gridDefYvals: Define the values of a Y-axis */
void    gridDefYvals(int gridID, double *yvals);

/*      gridInqYvals: Get all values of a Y-axis */
int     gridInqYvals(int gridID, double *yvals);

/*      gridDefXname: Define the name of a X-axis */
void    gridDefXname(int gridID, char *xname);

/*      gridDefXlongname: Define the longname of a X-axis  */
void    gridDefXlongname(int gridID, char *xlongname);

/*      gridDefXunits: Define the units of a X-axis */
void    gridDefXunits(int gridID, char *xunits);

/*      gridDefYname: Define the name of a Y-axis */
void    gridDefYname(int gridID, char *yname);

/*      gridDefYlongname: Define the longname of a Y-axis */
void    gridDefYlongname(int gridID, char *ylongname);

/*      gridDefYunits: Define the units of a Y-axis */
void    gridDefYunits(int gridID, char *yunits);

/*      gridInqXname: Get the name of a X-axis */
void    gridInqXname(int gridID, char *xname);

/*      gridInqXlongname: Get the longname of a X-axis */
void    gridInqXlongname(int gridID, char *xlongname);

/*      gridInqXstdname: Get the standard name of a X-axis */
void    gridInqXstdname(int gridID, char *xstdname);

/*      gridInqXunits: Get the units of a X-axis */
void    gridInqXunits(int gridID, char *xunits);

/*      gridInqYname: Get the name of a Y-axis */
void    gridInqYname(int gridID, char *yname);

/*      gridInqYlongname: Get the longname of a Y-axis */
void    gridInqYlongname(int gridID, char *ylongname);

/*      gridInqYstdname: Get the standard name of a Y-axis */
void    gridInqYstdname(int gridID, char *ystdname);

/*      gridInqYunits: Get the units of a Y-axis */
void    gridInqYunits(int gridID, char *yunits);

/*      gridDefPrec: Define the precision of a Grid */
void    gridDefPrec(int gridID, int prec);

/*      gridInqPrec: Get the precision of a Grid */
int     gridInqPrec(int gridID);

/*      gridInqXval: Get one value of a X-axis */
double  gridInqXval(int gridID, int index);

/*      gridInqYval: Get one value of a Y-axis */
double  gridInqYval(int gridID, int index);

double  gridInqXinc(int gridID);
double  gridInqYinc(int gridID);

int     gridIsCyclic(int gridID);
int     gridIsRotated(int gridID);
double  gridInqXpole(int gridID);
void    gridDefXpole(int gridID, double xpole);
double  gridInqYpole(int gridID);
void    gridDefYpole(int gridID, double ypole);
double  gridInqAngle(int gridID);
void    gridDefAngle(int gridID, double angle);
void    gridDefTrunc(int gridID, int trunc);
int     gridInqTrunc(int gridID);
/* Hexagonal GME grid */
int     gridInqGMEnd(int gridID);
void    gridDefGMEnd(int gridID, int nd);
int     gridInqGMEni(int gridID);
void    gridDefGMEni(int gridID, int ni);
int     gridInqGMEni2(int gridID);
void    gridDefGMEni2(int gridID, int ni2);
int     gridInqGMEni3(int gridID);
void    gridDefGMEni3(int gridID, int ni3);

void    gridDefArea(int gridID, double *area);
void    gridInqArea(int gridID, double *area);
int     gridHasArea(int gridID);

/*      gridDefNvertex: Define the number of vertex of a Gridbox */
void    gridDefNvertex(int gridID, int nvertex);

/*      gridInqNvertex: Get the number of vertex of a Gridbox */
int     gridInqNvertex(int gridID);

/*      gridDefXbounds: Define the bounds of a X-axis */
void    gridDefXbounds(int gridID, double *xbounds);

/*      gridInqXbounds: Get the bounds of a X-axis */
int     gridInqXbounds(int gridID, double *xbounds);

/*      gridDefYbounds: Define the bounds of a Y-axis */
void    gridDefYbounds(int gridID, double *ybounds);

/*      gridInqYbounds: Get the bounds of a Y-axis */
int     gridInqYbounds(int gridID, double *ybounds);

void    gridDefRowlon(int gridID, int nrowlon, int *rowlon);
void    gridInqRowlon(int gridID, int *rowlon);
void    gridChangeType(int gridID, int gridtype);
int     gridToZonal(int gridID);
int     gridToMeridional(int gridID);
int     gridToCell(int gridID);
int     gridToCurvilinear(int gridID);

/* ZAXIS routines */

void    zaxisName(int zaxistype, char *gridname);

/*      zaxisCreate: Create a vertical Z-axis */
int     zaxisCreate(int zaxistype, int size);

/*      zaxisDestroy: Destroy a vertical Z-axis */
void    zaxisDestroy(int zaxisID);

/*      zaxisInqType: Get the type of a Z-axis */
int     zaxisInqType(int zaxisID);

/*      zaxisInqSize: Get the size of a Z-axis */
int     zaxisInqSize(int zaxisID);

/*      zaxisDuplicate: Duplicate a Z-axis */
int     zaxisDuplicate(int zaxisID);

void    zaxisResize(int zaxisID, int size);

void    zaxisPrint(int zaxisID);
int     zaxisSize(void);

/*      zaxisDefLevels: Define the levels of a Z-axis */
void    zaxisDefLevels(int zaxisID, double *levels);

/*      zaxisInqLevels: Get all levels of a Z-axis */
void    zaxisInqLevels(int zaxisID, double *levels);

/*      zaxisDefLevel: Define one level of a Z-axis */
void    zaxisDefLevel(int zaxisID, int levelID, double levels);

/*      zaxisInqLevel: Get one level of a Z-axis */
double  zaxisInqLevel(int zaxisID, int levelID);

/*      zaxisDefName: Define the name of a Z-axis */
void    zaxisDefName(int zaxisID, const char *name);

/*      zaxisDefLongname: Define the longname of a Z-axis */
void    zaxisDefLongname(int zaxisID, const char *longname);

/*      zaxisDefUnits: Define the units of a Z-axis */
void    zaxisDefUnits(int zaxisID, const char *units);

/*      zaxisInqName: Get the name of a Z-axis */
void    zaxisInqName(int zaxisID, char *name);

/*      zaxisInqLongname: Get the longname of a Z-axis */
void    zaxisInqLongname(int zaxisID, char *longname);

/*      zaxisInqUnits: Get the units of a Z-axis */
void    zaxisInqUnits(int zaxisID, char *units);

void    zaxisDefPrec(int zaxisID, int prec);
int     zaxisInqPrec(int zaxisID);

void    zaxisDefLtype(int zaxisID, int ltype);
int     zaxisInqLtype(int zaxisID);

const double *zaxisInqLevelsPtr(int zaxisID);
void    zaxisDefVct(int zaxisID, int size, const double *vct);
int     zaxisInqVctSize(int zaxisID);
const double *zaxisInqVctPtr(int zaxisID);
int     zaxisInqLbounds(int zaxisID, double *lbounds);
int     zaxisInqUbounds(int zaxisID, double *ubounds);
int     zaxisInqWeights(int zaxisID, double *weights);
double  zaxisInqLbound(int zaxisID, int index);
double  zaxisInqUbound(int zaxisID, int index);
void    zaxisDefLbounds(int zaxisID, double *lbounds);
void    zaxisDefUbounds(int zaxisID, double *ubounds);
void    zaxisDefWeights(int zaxisID, double *weights);
void    zaxisChangeType(int zaxisID, int zaxistype);

/* TAXIS routines */

/*      taxisCreate: Create a Time axis */
int     taxisCreate(int timetype);

/*      taxisDestroy: Destroy a Time axis */
void    taxisDestroy(int taxisID);

int     taxisDuplicate(int taxisID);

void    taxisCopyTimestep(int taxisIDdes, int taxisIDsrc);

void    taxisDefType(int taxisID, int type);

/*      taxisDefVdate: Define the verification date */
void    taxisDefVdate(int taxisID, int date);

/*      taxisDefVtime: Define the verification time */
void    taxisDefVtime(int taxisID, int time);

/*      taxisDefRdate: Define the reference date */
void    taxisDefRdate(int taxisID, int date);

/*      taxisDefRtime: Define the reference date */
void    taxisDefRtime(int taxisID, int time);

/*      taxisDefCalendar: Define the calendar */
void    taxisDefCalendar(int taxisID, int calendar);

void    taxisDefTunit(int taxisID, int tunit);

void    taxisDefNumavg(int taxisID, int numavg);

int     taxisInqType(int taxisID);

/*      taxisInqVdate: Get the verification date */
int     taxisInqVdate(int taxisID);

/*      taxisInqVtime: Get the verification time */
int     taxisInqVtime(int taxisID);

/*      taxisInqRdate: Get the reference date */
int     taxisInqRdate(int taxisID);

/*      taxisInqRtime: Get the reference time */
int     taxisInqRtime(int taxisID);

/*      taxisInqCalendar: Get the calendar */
int     taxisInqCalendar(int taxisID);

int     taxisInqTunit(int taxisID);

int     taxisInqNumavg(int taxisID);

char   *tunitNamePtr(int tunitID);


/* Institut routines */

int     institutDef(int center, int subcenter, const char *name, const char *longname);
int     institutInq(int center, int subcenter, const char *name, const char *longname);
int     institutInqNumber(void);
int     institutInqCenter(int instID);
int     institutInqSubcenter(int instID);
char   *institutInqNamePtr(int instID);
char   *institutInqLongnamePtr(int instID);

/* Model routines */

int     modelDef(int instID, int modelgribID, const char *name);
int     modelInq(int instID, int modelgribID, char *name);
int     modelInqInstitut(int modelID);
int     modelInqGribID(int modelID);
char   *modelInqNamePtr(int modelID);

/* Table routines */

void    tableWriteC(const char *filename, int tableID);
void    tableWrite(const char *filename, int tableID);
int     tableRead(const char *tablefile);
int     tableDef(int modelID, int tablenum, const char *tablename);

char   *tableInqNamePtr(int tableID);
void    tableDefEntry(int tableID, int code, const char *name, const char *longname, const char *units);

int     tableInq(int modelID, int tablenum, const char *tablename);
int     tableInqNumber(void);

int     tableInqNum(int tableID);
int     tableInqModel(int tableID);

void    tableInqPar(int tableID, int code, char *name, char *longname, char *units);

int     tableInqParCode(int tableID, char *name, int *code);
int     tableInqParName(int tableID, int code, char *name);
int     tableInqParLongname(int tableID, int code, char *longname);
int     tableInqParUnits(int tableID, int code, char *units);

char   *tableInqParNamePtr(int tableID, int parID);
char   *tableInqParLongnamePtr(int tableID, int parID);
char   *tableInqParUnitsPtr(int tableID, int parID);

/* History routines */

void    streamDefHistory(int streamID, int size, const char *history);
int     streamInqHistorySize(int streamID);
void    streamInqHistoryString(int streamID, char *history);

#if defined (__cplusplus)
}
#endif

#endif  /* _CDI_H */
