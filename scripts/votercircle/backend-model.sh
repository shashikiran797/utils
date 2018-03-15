# Sample usage
# ./backend-model.sh SendSms sendSms send_sms parentModule

echo "$1" "$2" "$3" "$4"
PARENT_MODULE=$4
BASE_PATH=`pwd`
DASH_CASE=$(perl -ne 'print lc(join("-", split(/(?=[A-Z])/)))' <<< $1 )
MODEL_FILE="$DASH_CASE.mjs"
DATA_FILE="${DASH_CASE}-data.mjs"
DATA_SPEC_FILE="${DASH_CASE}-data.spec.mjs"
SCHEMA_FILE="${DASH_CASE}-schema.mjs"
SCHEMA_SPEC_FILE="${DASH_CASE}-schema.spec.mjs"
SERVICE_FILE="${DASH_CASE}-service.mjs"
SERVICE_SPEC_FILE="${DASH_CASE}-service.spec.mjs"
UPPER_CASE=$( awk '{print toupper($0)}' <<< $1 )
CAMEL_CASE=$1
OBJECT_CASE=$2
UNDER_SCORE_CASE=$3
mkdir ./src/shared/data/${DASH_CASE}
mkdir ./src/service/${DASH_CASE}

#########################
#  Generate model file  #
#########################
cat > "$BASE_PATH/src/shared/model/$MODEL_FILE" << end

import {
    VCModel
} from './base-model.mjs';

export class ${CAMEL_CASE} extends VCModel {
    static get tableName() {
        return '${UNDER_SCORE_CASE}';
    }
    static get relationMappings() {
        // return {
        //     plan: {
        //         relation: VCModel.BelongsToOneRelation,
        //         modelClass: Plan,
        //         join: {
        //             from: 'settings.id_plan',
        //             to: 'plan.id'
        //         }
        //     }
        // };
    }

    static add${CAMEL_CASE}(args, ctx) {
        return this.query(ctx.trx)
            .insert(args['${OBJECT_CASE}']);
    }

    static async update${CAMEL_CASE}(args, ctx) {
        return await this.query(ctx.trx)
            .update(args['${OBJECT_CASE}'])
            .where('id', args['id_campaign'])
    }
    static async fetch${CAMEL_CASE}ByCampaignId(args) {
        return await this.query()
            .where('id_campaign', args['id_campaign'])
            .page(args['skip'], args['limit']);
    }
}

end


#########################
#  Generate data file   #
#########################
cat > "$BASE_PATH/src/shared/data/${DASH_CASE}/${DATA_FILE}" << end
import {
    ${CAMEL_CASE}
} from '../../model/index.mjs';
import {
    ajv,
    VError
} from '../../validation.mjs';
import {
    loggingDecorator
} from '../../logging';

export default {

    _fetch${CAMEL_CASE}ByCampaignId: loggingDecorator('_fetch${CAMEL_CASE}ByCampaignId', async(args, ctx) => {
        /*
        args = {
            id_campaign: "ll"
        }
        */
        let validate = ajv.compile({
            type: 'object',
            required: ['id_campaign', 'skip', 'limit'],
            properties: {
                'id_campaign': {
                    type: 'string',
                    errorMessage: {
                        type: '"id_campaign" should be of type string'
                    }
                }
            },
            errorMessage: {
                type: '"args" should be of type object',
                required: '"id_campaign" is mandatory'
            }
        });
        const valid = validate(args);
        if (!valid) {
            throw new VError(validate.errors[0].message);
        }
        return await ${CAMEL_CASE}.fetch${CAMEL_CASE}ByCampaignId(args);
    }),
    _create${CAMEL_CASE}: loggingDecorator('_create${CAMEL_CASE}', async(args, ctx) => {
       
        let validate = ajv.compile({
            type: 'object',
            required: ['id_campaign'],
            properties: {
                ${OBJECT_CASE}: {
                    type: 'object',
                    errorMessage: {
                        type: '"${OBJECT_CASE}" should be of type object'
                    }
                },
                'id_campaign': {
                    type: 'string',
                    errorMessage: {
                        type: '"id_campaign" should be of type string'
                    }
                }
            },
            errorMessage: {
                type: '"args" should be of type object',
                required: '"${OBJECT_CASE}" is mandatory'
            }
        });
        const valid = validate(args);
        if (!valid) {
            throw new VError(validate.errors[0].message);
        }
        args['${OBJECT_CASE}']['id_campaign'] = args['id_campaign'];
        return await ${CAMEL_CASE}.add${CAMEL_CASE}(args, ctx);
    }),
    _update${CAMEL_CASE}: loggingDecorator('_update${CAMEL_CASE}', async(args, ctx) => {
       
        let validate = ajv.compile({
            type: 'object',
            required: ['id', '${OBJECT_CASE}'],
            properties: {
                ${OBJECT_CASE}: {
                    type: 'object',
                    errorMessage: {
                        type: '"${OBJECT_CASE}" should be of type object'
                    }
                },
                'id': {
                    type: 'string',
                    errorMessage: {
                        type: '"id" should be of type string'
                    }
                }
            },
            errorMessage: {
                type: '"args" should be of type object',
                required: '"${OBJECT_CASE}" is mandatory'
            }
        });
        const valid = validate(args);
        if (!valid) {
            throw new VError(validate.errors[0].message);
        }
        args['${OBJECT_CASE}']['id'] = args['id'];
        return await ${CAMEL_CASE}.update${CAMEL_CASE}(args, ctx);
    })
}

end



##############################
#  Generate data spec file   #
#############################
cat > "$BASE_PATH/src/shared/data/${DASH_CASE}/${DATA_SPEC_FILE}" << end
import {
    beforeEach,
    afterEach,
    describe,
    it
} from 'mocha';
import {expect} from 'chai';
import sinon from 'sinon';

import data from './${DATA_FILE}';
import {Campaign} from '../../model/index.mjs';
import {ajv} from '../../validation.mjs';
import {logger} from '../../logging.mjs';

describe("${CAMEL_CASE} Data", () => {
    describe("${CAMEL_CASE} Data _fetch${CAMEL_CASE}ByCampaignId", () => {
        let campaignStub, sandbox;
        beforeEach(() => {
            sandbox = sinon.sandbox.create();
            campaignStub = sandbox.stub(Campaign, 'fetch${CAMEL_CASE}ByCampaignId').resolves(42);
            sandbox.stub(logger, 'info');
            sandbox.stub(logger, 'error');
            sandbox.stub(logger, 'debug');
        });

        afterEach(() => {
            sandbox.restore()
        });

        it('fetch${CAMEL_CASE}ByCampaignId with valid params', () => {
            sandbox.stub(ajv, 'validate').returns(true);
            data._fetch${CAMEL_CASE}ByCampaignId({
                id: 1
            }, {
                logger: logger
            }).then(res => {
                expect(res).to.equal(42);
            });
        });

    })
});

end

############################
#   Generate schema file   #
############################
cat > "$BASE_PATH/src/schema/${PARENT_MODULE}/${SCHEMA_FILE}" << end
import {
    VError
} from "../../shared/validation.mjs";
import service from "../../service/index.mjs";


import {
    GraphQLSchema,
    GraphQLObjectType,
    GraphQLList,
    GraphQLID,
    GraphQLString,
    GraphQLInt,
    GraphQLFloat,
    GraphQLNonNull,
    GraphQLInputObjectType,
    GraphQLUnionType
} from "graphql";

import GraphQLJSON from "graphql-type-json";
import {
    GraphQLDateTime
} from "graphql-iso-date";

import
UnionInputType
from 'graphql-union-input-type';

import {
    pubsub
} from '../utils.mjs';

import {
    withFilter
} from 'graphql-subscriptions';

export const ${OBJECT_CASE}Type = new GraphQLObjectType({
    name: "${CAMEL_CASE}",
    description: "This is a ${CAMEL_CASE} type",
    fields: () => ({
        id: {
            type: new GraphQLNonNull(GraphQLID),
            description: "The unique id of the campaign"
        }
    })
});

const ${OBJECT_CASE}IdType = new GraphQLInputObjectType({
    name: "${OBJECT_CASE}Type",
    fields: {
        id: {
            type: new GraphQLNonNull(GraphQLString)
        }
    }
});

var ${OBJECT_CASE}QueryInputType = UnionInputType({
    name: '${OBJECT_CASE}QueryInput',
    resolveTypeFromAst: (ast) => {
        if (ast.fields[0] && ast.fields[0].name.value === 'id') {
            return campaignIdType;
        } else {
            return campaignPublicIdType;
        }
    }
});

export const ${OBJECT_CASE}Queries = new GraphQLObjectType({
    campaign: {
        type: ${OBJECT_CASE}Type,
        args: {
            input: {
                type: ${OBJECT_CASE}QueryInputType,
                description: "The public id of the ${OBJECT_CASE} that needs to be fetched"
            }
        },
        resolve: async(root, args, ctx) => {
            try {
                return await service.${OBJECT_CASE}.${CAMEL_CASE}ById(args, ctx);
            } catch (err) {
                ctx.logger.error(new VError(err, "${CAMEL_CASE}"));
                throw new Error(
                    '{"code": 500, "msg": "Internal Server Error"}'
                );
            }
        }
    }
});


const ${OBJECT_CASE}Mutations = {
    add${CAMEL_CASE}: {
        type: ${OBJECT_CASE}Type,
        description: 'Create a new ${OBJECT_CASE}',
        args: {
            id_campaign: {
                type: new GraphQLNonNull(GraphQLString)
            }
        },
        resolve: async(root, args, ctx) => {
            try {
                return await service.${OBJECT_CASE}.add${OBJECT_CASE}ToCampaign(args, ctx);
            } catch (err) {
                ctx.logger.error(new VError(err, 'add${CAMEL_CASE}'));
                throw new Error('{"code": 500, "msg": "Internal Server Error"}');
            }
        }
    },
    update${CAMEL_CASE}: {
        type: ${OBJECT_CASE}Type,
        description: 'Update an existing ${OBJECT_CASE}',
        args: {
            id: {
                type: new GraphQLNonNull(GraphQLString)
            },
            ${OBJECT_CASE}: {
                type: ${OBJECT_CASE}InputType
            }
        },
        resolve: async(root, args, ctx) => {
            try {
                return await service.${OBJECT_CASE}.update${CAMEL_CASE}(args, ctx);
            } catch (err) {
                ctx.logger.error(new VError(err, 'update${CAMEL_CASE}'));
                throw new Error('{"code": 500, "msg": "Internal Server Error"}');
            }
        }
    }
}


const ${OBJECT_CASE}ListType = new GraphQLObjectType({
    name: "${OBJECT_CASE}List",
    description: "This is a ${OBJECT_CASE} list type",
    fields: () => ({
        results: {
            type: new GraphQLList(${OBJECT_CASE}Type),
            description: "list of ${OBJECT_CASE}s"
        },
        total: {
            type: GraphQLInt,
            description: "total number of ${OBJECT_CASE}"
        }
    })
});

export {
    ${OBJECT_CASE}Type,
    ${OBJECT_CASE}InputType,
    ${OBJECT_CASE}ListType,
    ${OBJECT_CASE}Mutations,
    ${OBJECT_CASE}Queries,
};

end


################################
#   Generate schema spec file  #
################################
cat > "$BASE_PATH/src/schema/${PARENT_MODULE}/${SCHEMA_SPEC_FILE}" << end
import {
    beforeEach,
    afterEach,
    describe,
    it
} from 'mocha';
import {
    expect
} from 'chai';
import sinon from 'sinon';
import * as _ from 'underscore';

import {
    GraphQLList,
    GraphQLID,
    GraphQLString,
    GraphQLInt,
    GraphQLFloat,
    GraphQLNonNull
} from 'graphql';
import {
    GraphQLDateTime
} from 'graphql-iso-date';
import {  } from './${SCHEMA_FILE}';
import {logger} from '../../shared/logging.mjs';

describe("${CAMEL_CASE} Schema", () => {
    it('Should have an id field of type ID (non null)', () => {
        expect(${OBJECT_CASE}Type.getFields()).to.have.property('id');
        expect(${OBJECT_CASE}Type.getFields().id.type).to.deep.equals(new GraphQLNonNull(GraphQLID));
    });
});

end

############################
#   Generate service file  #
############################
cat > "$BASE_PATH/src/service/${DASH_CASE}/${SERVICE_FILE}" << end

import {
    loggingDecorator
} from '../../shared/logging.mjs';
import {
    ajv,
    VError
} from '../../shared/validation.mjs';
import data from '../../shared/data/index.mjs';

import {
    createTransaction,
    checkAccess
} from './../utils.mjs';

export default {
    create${CAMEL_CASE}: loggingDecorator('create${CAMEL_CASE}', async(args, ctx) => {
        let validate = ajv.compile({
            type: 'object',
            required: ['campaign'],
            properties: {
                'campaign': {
                    type: 'object',
                    errorMessage: {
                        type: "'campaign' should be of type object"
                    }
                }
            },
            errorMessage: {
                type: "'args' should be of type object",
                required: "'campaign' is mandatory"
            }
        });
        const valid = validate(args);

        if (!valid) {
            throw new VError(validate.errors[0].message);
        }
        const accessResponse = await checkAccess("create${CAMEL_CASE}", args["id_campaign"], ctx);
        if (!accessResponse.authorized) {
            throw new VError("not authorized!")
        }
        try {
            const ${OBJECT_CASE} = await data.${OBJECT_CASE}._create${CAMEL_CASE}(args, ctx);
            return ${OBJECT_CASE};
        } catch (err) {
            throw new VError(err, "create${CAMEL_CASE}");
        }
    }),

    fetch${CAMEL_CASE}ByCampaignId: loggingDecorator('fetch${CAMEL_CASE}ByCampaignId', async(args, ctx) => {
        let validate = ajv.compile({
            type: 'object',
            required: ['id_campaign'],
            properties: {
                'id_campaign': {
                    type: 'string',
                    errorMessage: {
                        type: "'campaign' should be of type object"
                    }
                }
            },
            errorMessage: {
                type: "'args' should be of type object",
                required: "'campaign' is mandatory"
            }
        });
        const valid = validate(args);

        if (!valid) {
            throw new VError(validate.errors[0].message);
        }
        const accessResponse = await checkAccess("uploadVoterFile", args["id_campaign"], ctx);
        if (!accessResponse.authorized) {
            throw new VError("not authorized!")
        }
        try {
            const ${OBJECT_CASE} = await data.${OBJECT_CASE}._fetch${CAMEL_CASE}ByCampaignId(args, ctx);
            return ${OBJECT_CASE};
        } catch (err) {
            throw new VError(err, "fetch${CAMEL_CASE}ByCampaignId");
        }
    }),
    update${CAMEL_CASE}: loggingDecorator('update${CAMEL_CASE}', async(args, ctx) => {
        let validate = ajv.compile({
            type: 'object',
            required: ['id', '${OBJECT_CASE}'],
            properties: {
                'id': {
                    type: 'string',
                    errorMessage: {
                        type: "'campaign' should be of type string"
                    }
                },
                '${OBJECT_CASE}': {
                    type: 'object',
                    errorMessage: {
                        type: "'${OBJECT_CASE}' should be an object"
                    }
                }
            },
            errorMessage: {
                type: "'args' should be of type object",
                required: "'campaign' is mandatory"
            }
        });
        const valid = validate(args);

        if (!valid) {
            throw new VError(validate.errors[0].message);
        }
        // const accessResponse = await checkAccess("update${CAMEL_CASE}", args["${OBJECT_CASE}"]["id_campaign"], ctx);
        const accessResponse = {
            authorized: true
        };
        if (!accessResponse.authorized) {
            throw new VError("not authorized!")
        }
        try {
            const ${OBJECT_CASE} = await data.${OBJECT_CASE}._update${CAMEL_CASE}(args, ctx);
            return ${OBJECT_CASE};
        } catch (err) {
            throw new VError(err, "update${CAMEL_CASE}");
        }
    })
    
}

end



#################################
#   Generate service spec file  #
#################################
cat > "$BASE_PATH/src/service/${DASH_CASE}/${SERVICE_SPEC_FILE}" << end
import {
    beforeEach,
    afterEach,
    describe,
    it
} from 'mocha';
import {
    expect
} from 'chai';
import sinon from 'sinon';
import * as _ from 'underscore';

import data from '../../shared/data/index.mjs';
import service from './campaign-service.mjs';
import {logger} from '../../shared/logging.mjs';

describe("${CAMEL_CASE} Service", () => {
    describe( "fetch${CAMEL_CASE}ById Method", () => {
        it('Must have method fetch${CAMEL_CASE}ById', () => {
            expect(service).to.have.property('fetchCampaignById');
        });

        beforeEach(() => {
            sandbox = sinon.sandbox.create();
            fetchStub = sandbox.stub(data.campaign, '_fetch${CAMEL_CASE}ById');
            loggerStub = sandbox.stub(logger, 'info');
        });

        afterEach(() => {
            sandbox.restore()
        });
    });
});

end



## Index files
echo '## Data ##'
echo "import ${UNDER_SCORE_CASE} from './${DASH_CASE}/${DATA_FILE}';";
echo "${OBJECT_CASE}: ${DASH_CASE}"

echo '## Model ##'
echo "
export {
    ${CAMEL_CASE}
}
from './${MODEL_FILE}'"

echo '## Service ##'
echo "import ${UNDER_SCORE_CASE} from './${DASH_CASE}/${SERVICE_FILE}';";
echo "${OBJECT_CASE}: ${DASH_CASE}"