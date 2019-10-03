const typescriptParser = require('typescript-parser');
const _ = require('lodash');
const fs = require('fs');
var TypescriptParser = require("typescript-parser").TypescriptParser
const parser = new TypescriptParser();
const code = `
import { Component, Input } from '@angular/core';
import * as _ from 'underscore';

import { Menu, MenuItem } from './campaign-subheader.model';

@Component({
    selector: 'vc-campaign-subheader',
    templateUrl: './campaign-subheader.component.html',
    styleUrls: ['./campaign-subheader.component.scss']
})

export class CampaignSubheaderComponent {
    @Input() routerData: any;
    @Input() campaignPublicId: string;
    canvassersMenu: Menu;
    organizersMenu: Menu;
    settingsMenu: Menu;
    accountsMenu: Menu;

    constructor() {
        this.initializeMenuItem();
    }

    initializeMenuItem(): void {
        this.canvassersMenu = new Menu({
            name: 'canvassers',
            items: [
                new MenuItem({
                    id: 'recruitment_settings',
                    title: 'Recruitment Settings',
                    link: 'wizard-settings'
                }),
                new MenuItem({
                    id: 'canvasser_instructions',
                    title: 'Canvasser instructions',
                    link: 'supporters/instructions'
                }),
                new MenuItem({
                    id: 'email_templates',
                    title: 'Email templates',
                    link: 'email-templates'
                }),
                new MenuItem({
                    id: 'manage_canvassers',
                    title: 'Manage canvassers',
                    link: 'supporters/manage'
                }),
                new MenuItem({
                    id: 'event_signup',
                    title: 'Event signup',
                    link: 'supporters/signup'
                })
            ]
        });

        this.organizersMenu = new Menu({
            name: 'organizers',
            items: [
                new MenuItem({
                    id: 'manage',
                    title: 'Manage',
                    link: 'organizers'
                }),
                new MenuItem({
                    id: 'leaderboard',
                    title: 'Leaderboard',
                    link: 'organizer-leaderboard'
                })
            ]
        });

        this.settingsMenu = new Menu({
            name: 'settings',
            items: [
                new MenuItem({
                    id: 'voter_file',
                    title: 'Voter File',
                    link: 'voter-data'
                }),
                new MenuItem({
                    id: 'voter_filters',
                    title: 'Voter Filters',
                    link: 'voter-filters'
                }),
                new MenuItem({
                    id: 'admin',
                    title: 'Admin',
                    link: 'admin'
                }),
                new MenuItem({
                    id: 'campaign_info',
                    title: 'Campaign info',
                    link: 'campaign-info'
                }),
                new MenuItem({
                    id: 'integrations',
                    title: 'Integrations',
                    link: 'integrations'
                })
            ]
        });

        this.accountsMenu = new Menu({
            name: 'accounts',
            items: [
                new MenuItem({
                    id: 'billing_and_payment',
                    title: 'Billing and Payment',
                    link: 'billing-payment'
                }),
                new MenuItem({
                    id: 'plan_types',
                    title: 'Plan types',
                    link: 'plan-types'
                })
            ]
        });
    }

    getActiveClass(menuItem: string | Menu, root: boolean = true): boolean {
        if (root) {
            if (menuItem === this.routerData['title']) {
                return true;
            } else {
                return false;
            }
        } else {
            if (_.pluck(menuItem['items'], 'title').indexOf(this.routerData['title']) !== -1) {
                return true;
            } else {
                return false;
            }
        }
    }
}
`;


async function tryOutCodeGen() {
    var Typescript = require("typescript-parser")
    var TypescriptParser = Typescript.TypescriptParser;
    const TypescriptCodeGenerator = Typescript.TypescriptCodeGenerator;
    const parser = new TypescriptParser();
    const code = `
    import { Module } from '@nestjs/common';
    import { TypeOrmModule } from '@nestjs/typeorm';

    import { DisclaimersModule } from '../disclaimer/disclaimer.module';
    import { ${declaration.name}sModule } from '../recruitment-settings/recruitment-settings.module';
    import { Campaign } from './campaign.entity';
    import { CampaignResolver } from './campaign.resolver';
    import { CampaignService } from './campaign.service';

    @Module({
        components: [CampaignResolver, CampaignService],
        imports: [
        TypeOrmModule.forFeature([Campaign]),
        ${declaration.name}sModule,
        DisclaimersModule
        ]
    })
    export class CampaignsModule {}
    `;

    const parsed = await parser.parseSource(code);
    const newImport = await parser.parseSource(`import { SettingsService } from './settings/settings.service'`);
    parsed.imports = parsed.imports.concat(newImport.imports);


    const codeGenerator = new TypescriptCodeGenerator({
        eol: this.insertSemicolons ? ';' : '',
        multiLineWrapThreshold: 125,
        multiLineTrailingComma: true,
        spaceBraces: true,
        stringQuoteStyle: `'`,
        tabSize: 4,
    });
    codeGenerator.generate(parsed.imports[1]);
}

/**
 * function to generate a graphql schema from a entity file
 */
async function generateGraphQLSchema() {
    var TypescriptParser = typescriptParser.TypescriptParser;
    const TypescriptCodeGenerator = typescriptParser.TypescriptCodeGenerator;
    const parser = new TypescriptParser();
    const code = fs.readFileSync('/Users/shashikiranms/projects/vcbackend/src/database/entities/base.entity.ts', 'utf-8');

    let properties = '';
    const parsed = await parser.parseSource(code);
    if (parsed.declarations && parsed.declarations.length > 0) {
        parsed.declarations.forEach(declaration => {
            if (declaration instanceof typescriptParser.ClassDeclaration ) {
                declaration.properties.forEach(propertyDeclaration => {
                    properties += (propertyDeclaration.name === 'id') ?`\t${propertyDeclaration.name}: ${_.capitalize(propertyDeclaration.type)}!\n` : `\t${propertyDeclaration.name}: ${_.capitalize(propertyDeclaration.type)}\n`;
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
        });

    }
}
setTimeout(async () => {
    generateGraphQLSchema();
}, 2000);