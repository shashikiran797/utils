import { TypescriptParser, TypescriptCodeGenerator, ClassDeclaration } from 'typescript-parser';
import * as _ from 'lodash';
/**
 * function to generate a graphql schema from a entity file
 */
async function generateGraphQLSchema(file) {
    const parser = new TypescriptParser();

    let properties = '';
    const code = '';
    const parsed = await parser.parseSource(code);
    let constructorString = '';
    if (parsed.declarations && parsed.declarations.length > 0) {
        parsed.declarations.forEach(declaration => {
            if (declaration instanceof ClassDeclaration) {
                declaration.properties.forEach(propertyDeclaration => {
                    constructorString += `this.${propertyDeclaration.name} = ${objectCase}.${propertyDeclaration.name};\n`;
                    properties += (propertyDeclaration.name === 'id') ? `\t${propertyDeclaration.name}: ${_.capitalize(propertyDeclaration.type)}!\n` : `\t${propertyDeclaration.name}: ${_.capitalize(propertyDeclaration.type)}\n`;
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