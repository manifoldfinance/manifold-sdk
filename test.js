// Function that contains the pattern to be inspected (using an `with` statement)
function fn() {
    with ({ i: 0, v: 0 }) {
        return v;
    }
}

function printStatus(fn) {
    const status = %GetOptimizationStatus(fn);
    console.log(status.toString(2).padStart(12, '0'));

    if (status & (1 << 0)) {
        console.log("is function");
    }

    if (status & (1 << 1)) {
        console.log("is never optimized");
    }
    
    if (status & (1 << 2)) {
        console.log("is always optimized");
    }
    
    if (status & (1 << 3)) {
        console.log("is maybe deoptimized");
    }
    
    if (status & (1 << 4)) {
        console.log("is optimized");
    }
    
    if (status & (1 << 5)) {
        console.log("is optimized by TurboFan");
    }
    
    if (status & (1 << 6)) {
        console.log("is interpreted");
    }
    
    if (status & (1 << 7)) {
        console.log("is marked for optimization");
    }
    
    if (status & (1 << 8)) {
        console.log("is marked for concurrent optimization");
    }
    
    if (status & (1 << 9)) {
        console.log("is optimizing concurrently");
    }
    
    if (status & (1 << 10)) {
        console.log("is executing");
    }
    
    if (status & (1 << 11)) {
        console.log("topmost frame is turbo fanned");
    }
}

console.log('0. prepare function for optimization');
printStatus(fn);

console.log("1. fill type-info");
fn();

console.log('2. calls function to go from uninitialized -> pre-monomorphic -> monomorphic')
fn();
printStatus(fn);

%OptimizeFunctionOnNextCall(fn);

console.log('3. optimize function on next call')
printStatus(fn);

console.log('4. next call')
fn();

console.log('5. get optimization status')
printStatus(fn);
