const Module = require('./test.js');
const wasm = Module({wasmBinaryFile: 'test.wasm'});
wasm.onRuntimeInitialized = function() {
    console.log(wasm._main());
};