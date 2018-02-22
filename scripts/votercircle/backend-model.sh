# Sample usage
# ./backend-model.sh SendSms sendSms

echo "$1" "$2"
BASE_PATH=`pwd`
DASH_CASE=$(perl -ne 'print lc(join("-", split(/(?=[A-Z])/)))' <<< $1 )
MODEL_FILE="$DASH_CASE.model.mjs"
DATA_FILE="${DASH_CASE}-data.mjs"
ACTION_FILE="$DASH_CASE.action.mjs"
EFFECT_FILE="$DASH_CASE.effect.mjs"
PROVIDER_FILE="$DASH_CASE.mjs"
UPPER_CASE=$( awk '{print toupper($0)}' <<< $1 )
CAMEL_CASE=$1
OBJECT_CASE=$2
UNDER_SCORE_CASE=`echo ${CAMEL_CASE} | sed -r 's/([a-z0-9])([A-Z])/\1_\L\2/g'`
mkdir ./src/shared/data/${DASH_CASE}

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

    static fetch${CAMEL_CASE}ByCampaignId(args) {
        return this.query()
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
    Integration
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
    })

}

end