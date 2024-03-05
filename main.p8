pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

#include _init.lua
#include _game.lua
#include player.lua
#include utils.lua
#include level.lua
#include fleas.lua

__gfx__
7777777777777777777777770000000000000000000000000000000000000000f888ffffffffffff000000000000000000000000000000000000000000000000
7777777777777777777777770000000000000000000000000000000000000000ff228fffffff888f00cccc000000000000000000000000000000000000000000
7777777777777777777777770000000000000000000000000000000000000000ffff28ffffffa88f0c1cc1c00000000000000000000000000000000000000000
7777777777777777777777770000000000000000000000000000000000000000fffff28ffbfb888fc1cccc1c0000000000000000000000000000000000000000
7777777777777777777777770000000000000000000000000000000000000000ffffff8fffbbbfffcc1cc1cc0000000000000000000000000000000000000000
7777777777777777777777770000000000000000000000000000000000000000fffffff8fbbbbfffc1c11c1c0000000000000000000000000000000000000000
7776777777777677777777770000000000000000000000000000000000000000ffffffffbffbfbffc111111c0000000000000000000000000000000000000000
7777777777777777777777770000000000000000000000000000000000000000ffffffffffbfffff1cccccc10000000000000000000000000000000000000000
777777777677777777777777000000000000000000000000ffff888fffff888f0000000000000000000000000000000000000000000000000000000000000000
777777777777777777777777000000000000000000000000ffff888fffff888f0000000000000000000000000000000000000000000000000000000000000000
7777777777777776777777770000000000000000000000008ffb888f8ffb888f0000000000000000000000000000000000000000000000000000000000000000
777777777777677767777777000000000000000000000000f82fbbbff8ffbbbf0000000000000000000000000000000000000000000000000000000000000000
777777777667777776676777000000000000000000000000f82fbbbbf82fbbbf0000000000000000000000000000000000000000000000000000000000000000
676777766bb677766bb67776000000000000000000000000ff82bfbfff82bfbb0000000000000000000000000000000000000000000000000000000000000000
b677766bbbbb6776bbb6766b000000000000000000000000ff8222bffff882bf0000000000000000000000000000000000000000000000000000000000000000
bb666bbbbbbbb66bbbbb6bbb000000000000000000000000fff8888fffff88bf0000000000000000000000000000000000000000000000000000000000000000
bbbbbbb00000bbbbbbbbbbbb00000bbbbbbbbbbb00000bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb0999990bbbbbbbbbb0999990bbbbbbbbb0999990bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb0922270bbbbbbbbbb0922270bbbbbbbbb0922270bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb0c2272bbbbbbbbbbb0c2272bbbbbbbbbb0c2272bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb000cccc0bbbbbbbbb000cccc0bbbbbbbb000cccc0bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bb00999499990bbbbbbb09994999900bbbbb09994999900b00000000000000000000000000000000000000000000000000000000000000000000000000000000
b09949499944900bbbb0999499949990bbb099949994999000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0cc009994499c0bbbb0c909999409c0b000c909999409c000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb000eeeee90cc0bbbb0cc0999440cc0088800eeeeee000b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb022229908880bbbb00eeeeee000b0888022200220bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb0222009988880bbbbb02222220bbbb088099000220bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb099088888880bbbbb022200220bbbbb0080008802200b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bb009908888000bbb00009900009900bbbbb08888889988000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0888888000bbbbb0888099088099080bbbbb0088889988000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0888000bbbbbbbbb088888888888880bbbbbbb00088880b00000000000000000000000000000000000000000000000000000000000000000000000000000000
bb000bbbbbbbbbbbbb0000000000000bbbbbbbbbbb0000bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002020400000000000000000000000000020204040000000000000000000000000202040404000000000000000000000002020604040400000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4545454041424345454545000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545455051525300565745454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545456061626300666745454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545457071727300767745454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545450000000000008745454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545909192939495969745454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545a0a1a2a3a4a5a64545454500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4545454545454545454545450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
