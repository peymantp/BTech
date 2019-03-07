#!/usr/bin/node
const fs = require('fs');
const program = require('commander');
const OTP = require('./OTP')

//./index.js -f wap -e
//./index.js -k key -c cypher -d
program
    .version('1.0.0')
    .option('-f, --file <file>', 'File location is relative to JS file')
    .option('-k, --key <key>', 'Required only when mode is set to decrypting')
    .option('-c, --cypher <cypher>','Required only when mode is set to decrypting')
    .option('-e, --encrypt [encrypt]','encryption mode')
    .option('-d, --decrypt [decrypt]','decrypt mode')
    .parse(process.argv);

if(program.encrypt){
    var o = new OTP(program.file);
    o.encrypt();
    fs.writeFile('cypher', o.getCypher(), (err) => {  
        if (err) throw err;
        console.log('cypher saved!');
    });
    fs.writeFile('key', o.getKey(), (err) => {  
        if (err) throw err;
        console.log('key saved!');
    });
} else if (program.decrypt){
    try {
        c = fs.readFileSync(program.cypher, 'utf8');
    } catch (error) {
        throw('Error:', error.stack);
    }
    try {
        k = fs.readFileSync(program.key, 'utf8');
    } catch (error) {
        throw('Error:', error.stack);
    }
    var o = new OTP('',key=k,cypher=c);
    msg = o.decrypt();
    fs.writeFile('plain', msg, (err) => {  
        if (err) throw err;
        console.log('plain text saved!');
    });
} else {
    console.log("either decrypt or encrypt mode must be selected");
}