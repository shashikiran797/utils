const typescriptParser = require('typescript-parser');
const _ = require('lodash');
const fs = require('fs');
var TypescriptParser = typescriptParser.TypescriptParser
const parser = new TypescriptParser();

/**
 * function to generate a graphql schema from a entity file
 */
async function generateGraphQLSchema() {
    var TypescriptParser = typescriptParser.TypescriptParser;
    const TypescriptCodeGenerator = typescriptParser.TypescriptCodeGenerator;
    const parser = new TypescriptParser();
    const code = fs.readFileSync('/Users/shashikiranms/projects/database/src/entities/email-message.entity.ts', 'utf-8');

    let properties = '';
    let constructorString = '';
    const parsed = await parser.parseSource(code);
    if (parsed.declarations && parsed.declarations.length > 0) {
        parsed.declarations.forEach(declaration => {
            if (declaration instanceof typescriptParser.ClassDeclaration ) {
                declaration.properties.forEach(propertyDeclaration => {
                    let type = _.capitalize(propertyDeclaration.type);
                    if (type.toLowerCase() == 'number') {
                        type = 'Int';
                    }
                    if (type.indexOf('Array') > -1) {
                        type = _.capitalize(type.replace('Array', '').replace('<', '').replace('>', '') + '[]');
                    }
                    if (type.indexOf('[]') > -1) {
                        type = _.capitalize(type.replace('[]', '') + '[]');
                    }
                    constructorString += `this.${propertyDeclaration.name} = something.${propertyDeclaration.name};\n`;
                    properties += (propertyDeclaration.name === 'id') ?`\t${propertyDeclaration.name}: ${type}!\n` : `\t${propertyDeclaration.name}: ${type}\n`;
                });
            }
            const schema = `
type ${declaration.name} {
    ${properties}
}
            `;
            const schemaInput = `
input ${declaration.name}Input {
    ${properties}
}
            `;
            const objectCase = _.camelCase(declaration.name);
            const queries = `
type Query {
    ${objectCase}(id: String): ${declaration.name}
    ${objectCase}ByCampaignId(id_campaign: String): ${declaration.name}
}
             
            `;
            const mutations = `
type Mutation {
    ${objectCase}(id: String!,
    ${objectCase}: ${declaration.name}Input,
    id_campaign: String!): ${declaration.name}
                
    add${declaration.name}(${objectCase}: ${declaration.name}Input!,
        id_campaign: String!): ${declaration.name}
              
    delete${declaration.name}(id: String!): Boolean
}`;
            console.log(`=================== Graphql schema for ${declaration.name}  ==============`);
            console.log(schema);
            console.log(schemaInput);
            console.log(queries);
            console.log(mutations);
            console.log('=================== constructor ==============');
            console.log(constructorString);
        });

    }
}
setTimeout(async () => {
    generateGraphQLSchema();
}, 2000);
