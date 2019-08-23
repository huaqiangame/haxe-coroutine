package tests.basics;
import utest.Assert;
import coroutine.CoroutineSystem;
import haxe.Timer;
import coroutine.RoutineInstruction.*;

class WaitDelayTests {

    private var ch = new CoroutineSystem();

    public function new () {
        
    }

    private function loop () {

        ch.updateEnterFrame();
        ch.updateExitFrame();

        Timer.delay(loop, 16);
    }

    @:timeout(700)
    public function testDelay (async:utest.Async) {

        loop();

        var obj = { value: 0 };
        ch.startCoroutine( delay(obj) );

        var a = obj.value;
        var b = -1;
        var c = -1;
        
        Timer.delay(function () {
            b = obj.value;
        }, 300);

        Timer.delay(function () {
            c = obj.value;
            
            Assert.equals(1, a);
            Assert.equals(2, b);
            Assert.equals(3, c);

            async.done();
        }, 550);
    }

    function delay (obj:{ value:Int }) {
        
        obj.value = 1;
        @yield return WaitDelay(0.25);

        obj.value = 2;
        @yield return WaitDelay(0.25);

        obj.value = 3;
    }

}