pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

#include _init.lua
#include _game.lua
#include _gameover.lua
#include _victory.lua
#include _interlevel.lua
#include utils.lua
#include player.lua
#include level.lua
#include fleas.lua
#include timer.lua

__gfx__
00000000777777777777777777777777bbbbbbb6777777776bbbbbbb7777777bf888ffffffffffffccccccccccccccccccccccccccccccccbbbbbbb00000bbbb
00000000777777777777777777777777bbbbbb677777777776bbbbbb7c7777bbff228fffffff888fcccccccccccccccccccc666cccccccccbbbbbb0999990bbb
00707000777777777777777777777777bbbbb67777777777776bbbbb77777bbbffff28ffffffa88fccc6666666ccc666ccc66666ccc6666cbbbbbb0922270bbb
00070000777777777777777777777777bbbb6777777777777776bbbb7777bbbbfffff28ffbfb888f66666666666666666666666666666666bbbbb00c2272b00b
00707000777777777777777777777777bbb677777777777777776bbb777bbbbbffffff8fffbbbfff66666666666666666666666666666666bbb0099cccc00cc0
00000000777777777777777777777777bb67777777777777777776bb77bbbbbbfffffff8fbbbbfff66666666666666666666666666666666b0099994999999c0
00000000777777777777777777777777b6777777777777777777776b7bbbbbbbffffffffbffbfbff666666666666666666666666666666660cc949499994900b
00000000666777767767676667667767677777777777777777777776bbbbbbbbffffffffffbfffff666666666666666666666666666666660cc0009994490bbb
00000000777777777777777777777777777777750000000057777777bbbbbbbb000000006ddddddd777777776666d66666666666ddd6dd6db00bb0eeeeee000b
00000000777777777777777777777777777777570000000075777777bbbbbbb700000000d6dddddd777777776666666d66dd6666ddddd6ddbbbb022222220880
00000000777777777667777777777777777775770000000077577777bbbbbb7700000000dddd6ddd7777777766d6666666666d66d6ddddddbbb0222000990880
00000000677777766d66777666677777777757760000000077757777bbbb777700000000dd1dddd6777b77776d666dd66d66d666dd1dddd6bbb099088099880b
000000006677766666666666666d7776777577670000000077775777bbb7777700000000ddd1dddd7777b777d6666d666666666dddd1ddd1bb009908888000bb
000000006d66666d666666d666d6666d775776770000000067777577bb77787700000000ddddddd177777777666666666d6666661111dd1db0888888000bbbbb
00000000d66666d666666d666d6666d6757767760000000077777757b7777777000000001d1d11117777777766d666d66dd66d6d00001111b0888000bbbbbbbb
0000000066666d6666666666d6666d66577677670000000077776775777777770000000001110000777777776d6d6dd6d6666dd600000000bb000bbbbbbbbbbb
bbbbbbb00000bbbbbbbbbbbb00000bbbbbbbbbbb00000bbbbbbbbbb000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000
bbbbbb0999990bbbbbbbbbb0999990bbbbbbbbb0999990bbbbbbbb09990bbbbbbbbbbbbb000bbbbbbbbbbbbb000bbbbb00000000000000000000000000000000
bbbbbb0922270bbbbbbbbbb0922270bbbbbbbbb0922270bbbbbbbb099990bbbbbbbbbbb09990bbbbbbbbbbb09990bbbb00000000000000000000000000000000
bbbbbb0c2272bbbbbbbbbbb0c2272bbbbbbbbbb0c2272bbbbbbbbb022290bbbbbbbbbbb099990bbbbbbbbbb099990bbb00000000000000000000000000000000
bbbb000cccc0bbbbbbbbb000cccc0bbbbbbbb000cccc0bbbbbb000c22720bbbbbbbbbbb022290bbbbbbbbbb022290bbb00000000000000000000000000000000
bb00999499990bbbbbbb09994999900bbbbb09994999900bbb0999cccc0bbbbbbbbb000c22720bbbbbbb000c22720bbb00000000000000000000000000000000
b0994949994490bbbbb0999499949990bbb0999499949990b09499499990bbbbbbb0994cccc0bbbbbbb0994cccc0bbbb00000000000000000000000000000000
b0cc009994499c0bbbb0c909999409c0b000cc0999940cc0b09949999490bbbbbbb0949999940bbbb009949999940bbb00000000000000000000000000000000
bb000eeeee90cc0bbbb0cc0999440cc00880cceeeeee000bb099eeee4990000bbb099949994990bb08809949994990bb00000000000000000000000000000000
bbbb022229908880bbbb00eeeeee000b0888022200220bbbb0cc222099088880bb0cceeeee9990bb080cceeeee9990bb00000000000000000000000000000000
bbb0222009988880bbbbb02222220bbbb088099000220bbbbb00220299088880bbb0022222990bbbb080c22222490bbb00000000000000000000000000000000
bbb099088888880bbbbb022200220bbbbb0080088802200bbbb0990cc088880bbbbb022209990bbbbb0082220999000b00000000000000000000000000000000
bb009908888000bbb00009900009900bbbbb088888099080bb00990cc08000bbb00009900cc0000bbbbb09980cc0888000000000000000000000000000000000
b0888888000bbbbb0888099088099080bbbbb00888099080b0888888000bbbbb088809908cc88880bbbbb0088cc0888000000000000000000000000000000000
b0888000bbbbbbbbb088888888888880bbbbbbb00088880bb0888000bbbbbbbbb088888888888880bbbbbbb00088880b00000000000000000000000000000000
bb000bbbbbbbbbbbbb0000000000000bbbbbbbbbbb0000bbbb000bbbbbbbbbbbbb0000000000000bbbbbbbbbbb0000bb00000000000000000000000000000000
7c777c777c777c77bb00bbbbbbbbbbbbbbb3bbbbbbbb7bbbbbbb3bbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
777c777c777c777cb07300bbbbbbbbbbb3733bbbbbb733bbbbb737bbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7c7c70733330bbbbb3bbbbb737bbbbb77377bbb73337bbbbb7bbb0000000000000000000000000000000000000000000000000000000000000000
7c7c7c7c7c7c7c7cb07330bbbbb737bbb77337bbbbb737bbbbb737bbbb33733b0000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7c7c7b043330bbb7733bb3773333bbb37337bbb37377bbbb773bb0000000000000000000000000000000000000000000000000000000000000000
cc7ccc7ccc7ccc7c07333330b733433bbb377bbbbb733377b7373377bb77337b0000000000000000000000000000000000000000000000000000000000000000
c7c7c7c7c7c7c7c7b073330bbbb33bbbb33377bbb3733733b3737777b33337370000000000000000000000000000000000000000000000000000000000000000
7ccc7ccc7ccc7cccbb0330bbbb3337bb7337333b7bb33bbbbbb377bbbbb737bb0000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccccb033770bbbb433bbbbbbbb6bbbb6bbb6bbb66bbbbbb6bbbb0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc03334330bb33377bb6bb6636bb676b67666376bbbb676bbb0000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccccb0333330b333343367667637b673763763637766b636766b0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0773330bbb33333b736373636733676677363363636763760000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccccb043330b77333377363777766736363633363637367736370000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc07333330b33433bb336337637667376333636733677773660000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccccb044400b33333333363773363673373636737636777336370000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccccb04440bbbb444bbb677773336637777663777763633773630000000000000000000000000000000000000000000000000000000000000000
b4444bbb000000000000000000000000633336377363336363333633336333630000000000000000000000000000000000000000000000000000000000000000
477994bb000000000000000000000000763363637676363676336363367636360000000000000000000000000000000000000000000000000000000000000000
479994bb000000000000000000000000776677366777677377663736633767730000000000000000000000000000000000000000000000000000000000000000
b4444bbb000000000000000000000000336777336336777733677733633677770000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000367733733667737736773377366773770000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000677333377763377367733377376337730000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000773333773776337777377337777633770000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000333377737377637733337733773763770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000733773773733373377777773737773330000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000377737333337733337333337773333330000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000733333373377333773337337333337770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000773373777333377777777733377777770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
bbbbb00000bbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb0999990bbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb0922270bb00b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb0c22720b0cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb0cccc0b098800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb0099449909980b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b09994999949080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099949999490080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09909994490b080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b09ce94990bb080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb0c2eeee0bb080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb0222220bb080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb022202220b080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb022202220b080b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb0990b09900880b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b09990b0999080bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000000000000000000000000004040000000000000000000000000202040404000400000000000000000002020604040404040000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
40414041404140414041404140414041410a0b0c0d0102030406180000460000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000511a1b1c1d1a1a1a0505180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000545556571a1a1a1416000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000646566671112130505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000747576771b1c1b1b1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001d191d1d19000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001d1d1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
