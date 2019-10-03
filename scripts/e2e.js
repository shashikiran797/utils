var recast = require('recast');
const fs = require('fs');
const str = fs.readFileSync(process.argv[2], {
    encoding: 'utf-8'
})
var ast = recast.parse(str, {
  parser: require("recast/parsers/typescript")
});

const ignoreMethods = ['beforeAll', 'afterAll'];
let i = 0;
function parseBody(body, tab) {
    if (body.expression && body.expression.type === 'CallExpression') {
        if (body.expression.callee) {
            if (body.expression.callee.name) {
                if (ignoreMethods.includes(body.expression.callee.name)) {
                    return;
                }
            }
            const empty = isEmpty(body);
            if (body.expression.arguments && body.expression.arguments.length) {
                for (const arg of body.expression.arguments) {
                    if (arg.type.includes('Literal')) {
                        if (arg.value) {
                            console.log(tab + '* ' + arg.value, empty ? 'x' : '');
                            arg.value = 'A' + i++ + arg.value;
                        }
                    } else if (arg.type.includes('FunctionExpression')) {
                        if (body.expression.callee.name === 'it') {
                            return;
                        }
                        for (const childBody of arg.body.body) {
                            parseBody(childBody, tab + '\t');
                        }
                    }
                }
            }
        }
    }
}

function isEmpty(body) {
    if (body.expression.callee.name === 'it' && body.expression && body.expression.arguments && body.expression.arguments.length && body.expression.arguments[1]) {
        return !body.expression.arguments[1].body.body.length;
    }
    return false;
}


for (const body of ast.program.body) {
    parseBody(body, '\t');
}
console.log(recast.print(ast).code);

// console.log(JSON.stringify(ast.program.body[2].expression, null, 2));


// var recast = require('recast');
// var ast = recast.parse(`function a(some) {console.log('dsasd')}; 
// a('ast')`);
// console.log(ast.program.body);