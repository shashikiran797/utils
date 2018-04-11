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

setTimeout(async () => {
    const parsed = await parser.parseSource(code);
    console.log(parsed);
}, 2000);