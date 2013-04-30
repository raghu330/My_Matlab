function aa = flume_eval(fdir)

ff = dir([fdir,'*.dat']);

aa = read_swims_flume(fdir,ff(1).name);

a = {'lo','id','hi'};
d=[0.415 0.439 0.490];
I=strcmp(a,aa.name(end-10:end-9));
aa.h=d(I);

aa.dt = aa.time(2) - aa.time(1);

aa = upcrossing(aa);
aa = spec_analy(aa);
aa = reflection(aa);