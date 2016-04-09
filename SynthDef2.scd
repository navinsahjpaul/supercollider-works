// boot/reboot server + audio meter
(s.reboot; s.meter;)
// import ~/Code/Samples folder into a list called ~samples
(~samples = Array.new; ~folder = PathName.new("~/Code/samples/");)
( ~folder.entries.do({ arg path; ~samples = ~samples.add(Buffer.read(s, path.fullPath));});)
// SynthDefs
(
SynthDef.new(\mplay, {
  arg buf, rate=1, t_trig=1, start=0, loop=1, amp=1, att=10, gate=1, hpf=100, lpf=3000;
  var sig, env;
  sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, t_trig, start, loop, 2);
  sig = HPF.ar(sig, hpf);
  sig = LPF.ar(sig, lpf);
  sig = Pan2.ar(sig);
  env = EnvGen.kr(Env.asr(attackTime:att, curve:1), gate, doneAction:2);
  Out.ar(0, sig * amp * env);
}).add;
SynthDef.new(\splay, {
  arg buf, rate=1, t_trig=1, start=0, loop=1, amp=1, att=10, gate=1, hpf=100, lpf=3000;
  var sig, env;
  sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, start, loop, 2);
  sig = HPF.ar(sig, hpf);
  sig = LPF.ar(sig, lpf);
  env = EnvGen.kr(Env.asr(attackTime:att, curve:1), gate, doneAction:2);
  Out.ar(0, sig * amp * env);
}).add;
SynthDef.new(\mplayverb, {
  arg buf, rate=1, t_trig=1, start=0, loop=1, amp=1, att=10, gate=1, hpf=100, lpf=3000, mix=0.5, room=0.5, damp=0.5;
  var sig, env;
  sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, t_trig, start, loop, 2);
  sig = HPF.ar(sig, hpf);
  sig = LPF.ar(sig, lpf);
  sig = Pan2.ar(sig);
  sig = FreeVerb.ar(sig, mix, room, damp);
  env = EnvGen.kr(Env.asr(attackTime:att, curve:1), gate, doneAction:2);
  Out.ar(0, sig * amp * env);
}).add;
SynthDef.new(\splayverb, {
  arg buf, rate=1, t_trig=1, start=0, loop=1, amp=1, att=10, gate=1, hpf=100, lpf=3000, mix=0.5, room=0.5, damp=0.5;
  var sig, env;
  sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, start, loop, 2);
  sig = HPF.ar(sig, hpf);
  sig = LPF.ar(sig, lpf);
  sig = FreeVerb.ar(sig, mix, room, damp);
  env = EnvGen.kr(Env.asr(attackTime:att, curve:1), gate, doneAction:2);
  Out.ar(0, sig * amp * env);
}).add;
)
// Create Instances of Synths
(x = Synth.new(\mplay, [\buf, ~samples[1], \amp, 0.5, \hpf, 400, \lpf, 4000]);)
(y = Synth.new(\splay, [\buf, ~samples[2], \amp, 0.5, \hpf, 400, \lpf, 4000]);)
(r = Synth.new(\mplayverb, [\buf, ~samples[1], \amp, 0.5, \hpf, 400, \lpf, 4000, \mix, 1, \room, 1, \damp, 1]);)
(v = Synth.new(\splayverb, [\buf, ~samples[2], \amp, 0.5, \hpf, 400, \lpf, 4000, \mix, 1, \room, 1, \damp, 1]);)
(x.set(\rate, 0.4, \hpf, 1000, \lpf, 5000);)
(y.set(\rate, 1.4, \hpf, 100, \lpf, 500);)
(x.release(10);)
(y.release(20);)
(r.release(10);)
(v.release(10);)