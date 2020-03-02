package tests.benchs;

import haxe.ds.GenericStack;
import haxe.Timer;
import utest.Assert;
import coroutine.Routine;
import coroutine.CoroutineProcessor;
import tests.Tests.println;

class Starting implements utest.ITest {

    public function new () { }

    @:analyzer(ignore)
    public function testStarting () {

        var targetIteration = 10000;
        var pool = new GenericStack<Routine>();
        for(_ in 0...targetIteration + 1)
            pool.add(getCoroutine());

        var ch = new CoroutineProcessor();
        var startTime = Timer.stamp();
        var numSamples = 0;
        do {

            inline ch.startCoroutine( pool.pop() );

        } while(++numSamples < targetIteration);
        var endTime = Timer.stamp();
        var mu = (endTime - startTime) * 1000000.;
        println('Bench: starting = ${mu / numSamples} (μs)');

        utest.Assert.isTrue(true);
    }

    static function getCoroutine () {
        @yield return RoutineInstruction.WaitNextFrame;
    }
}