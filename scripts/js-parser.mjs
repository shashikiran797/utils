#!/usr/bin/node
import esprima from 'esprima';
import fs from 'fs';
import _ from 'lodash';
import Temp from '../temp';
async function parseFile(file) {
    try {
        const program = fs.readFileSync(file, 'utf-8');
        console.log(program);
        const temp = esprima.parseScript(program);
        console.log(JSON.stringify(temp, null, 2));
        return temp;
    } catch (error) {
        console.log(error);
        console.log('problem parsing the file');
    }
    return null;
}

// setTimeout(() => {
//     const result = parseTypescriptFile('/Users/shashikiranms/projects/vcapp4/src/src/app/shared/svg/svg-add-icon/svg-add-icon.component.ts');
// }, 3000);

async function parseTypescriptFile(file) {
    try {
        // const program = fs.readFileSync(file, 'utf-8');
        // console.log(program);
        const parser = new TypescriptParser;
        const parsed = await parser.parseFile(file);
        return temp;
    } catch (error) {
        console.log(error);
        console.log('problem parsing the file');
    }
    return null;
}

async function writeSvg(){
    _.each(Temp.temp, (svg) => {
        console.log(svg.selector);
        fs.writeFileSync(`/Users/shashikiranms/personal/utils/${svg.selector}.svg`, svg.template)
    })
    
}

setTimeout(() => {
    writeSvg();
}, 4000);