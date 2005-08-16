[general]
writeprotect=no

[globals]
CONSOLE=Console/dsp
IAXINFO=guest
TRUNK=Zap/g2
TRUNKMSD=1

[iaxtel700]
ext _91700XXXXXXX { 
  Dial(IAX2/${IAXINFO}@iaxtel.com/${EXTEN:1}@iaxtel) 
}

[iaxprovider]
;switch IAX2/user:[key]@myserver/mycontext

[trunkint]
ext _9011. {
  Dial(${TRUNK}/${EXTEN:${TRUNKMSD}})
  Congestion
}

[trunkld]
ext _91NXXNXXXXXX {
  Dial(${TRUNK}/${EXTEN:${TRUNKMSD}})
  Congestion
}

[trunklocal]
ext _9NXXXXXX {
  Dial(${TRUNK}/${EXTEN:${TRUNKMSD}})
  Congestion
}

[trunktollfree]
ext _91800NXXXXXX { 
  Dial(${TRUNK}/${EXTEN:${TRUNKMSD}})
  Congestion
}
ext _91888NXXXXXX { 
  Dial(${TRUNK}/${EXTEN:${TRUNKMSD}})
  Congestion
}
ext _91877NXXXXXX { 
  Dial(${TRUNK}/${EXTEN:${TRUNKMSD}})
  Congestion
}
ext _91866NXXXXXX { 
  Dial(${TRUNK}/${EXTEN:${TRUNKMSD}})
  Congestion
}

[international]
ignorepat 9
include longdistance
include trunkint

[longdistance]
ignorepat 9
include local
include trunkld

[local]
ignorepat 9
include default
include parkedcalls
include trunklocal
include iaxtel700
include trunktollfree
include iaxprovider

[macro-stdexten]
ext s { 
  Dial(${ARG2},20)
  Goto(s-${DIALSTATUS},1)
}

ext s-NOANSWER {
  Voicemail(u${ARG1})
  Goto(default,s,1)
}

ext s-BUSY {
  Voicemail(b${ARG1})
  Goto(default,s,1)
}

ext _s-. Goto(s-NOANSWER,1)

ext a VoicemailMain(${ARG1})

[demo]
ext s {
  Wait,1
  Answer
  DigitTimeout,5
  ResponseTimeout,10
  BackGround(demo-congrats)
  BackGround(demo-instruct)
}

ext 2 {
  BackGround(demo-moreinfo)
  Goto(s,6)
}

ext 3 {
  SetLanguage(fr)
  Goto(s,5)
}

ext 1000 Goto(default,s,1)

ext 1234 { 
  Playback(transfer,skip)
  Macro(stdexten,1234,${CONSOLE})
}

ext 1235 Voicemail(u1234)

ext 1236 {
1:   Dial(Console/dsp)
     Voicemail(u1236)
102: Voicemail(b1236)
}

ext # { 
  Playback(demo-thanks)
  Hangup
}

ext t Goto(#,1)
ext i Playback(invalid)

ext 500 { 
  Playback(demo-abouttotry)
  Dial(IAX2/guest@misery.digium.com/s@default)
  Playback(demo-nogo)
  Goto(s,6)
}

ext 600 {
  Playback(demo-echotest)
  Echo
  Playback(demo-echodone)
  Goto(s,6)
}

ext 8500 {
  VoicemailMain
  Goto(s,6)
}

[default]
include demo
