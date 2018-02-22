#!/usr/bin/node
import esprima from 'esprima';
import fs from 'graceful-fs';

async function analyzeCode(file) {
    try {
        const program = fs.readFileSync(file);
    } catch (error) {
        console.log('problem parsing the file');
    }
    const temp = esprima.parseScript(file);
    console.log(JSON.stringify(temp, null, 2));
}

module.exports = {
    analyzeCode,
}