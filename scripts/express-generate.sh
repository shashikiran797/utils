# Sample usage
# ./generate.sh SendSms sendSms

echo "$1" "$2"
BASE_PATH=`pwd`
DASH_CASE=$(perl -ne 'print lc(join("-", split(/(?=[A-Z])/)))' <<< $1 )
MODEL_FILE="$DASH_CASE.model.js"
CONTROLLER_FILE="$DASH_CASE.controller.js"
SERVICE_FILE="$DASH_CASE.service.js"
UPPER_CASE=$( awk '{print toupper($0)}' <<< $1 )
CAMEL_CASE=$1
# OBJECT_CASE=$2
OBJECT_CASE=foo="$(tr '[:lower:]' '[:upper:]' <<< ${CAMEL_CASE:0:1})${CAMEL_CASE:1}"
mkdir ./app/modules/${DASH_CASE}

#########################
#  Generate model file  #
#########################
cat > "$BASE_PATH/app/modules/${DASH_CASE}/${MODEL_FILE}" << end
import Mongoose from 'mongoose';
import MongooseDeepPopulate from 'mongoose-deep-populate';
const deepPopulate = MongooseDeepPopulate(Mongoose);

const ${CAMEL_CASE}Schema   = new mongoose.Schema({
    campusId:     { type: mongoose.Schema.Types.ObjectId, ref : 'Campus', required: true },
    campusApartmentDetailsId:     { type: mongoose.Schema.Types.ObjectId, ref : 'CampusApartmentDetails', required: true },
    isLoggedOut:    { type: Boolean, required: false },
    comments:       { type: String, required: false },
    status:         { type: Number, required: false, default: 3000 },
    updatedAt:      { type: Date, required: true, default: Date.now },
    createdAt:      { type: Date, required: true, default: Date.now },
});

${CAMEL_CASE}Schema.plugin(deepPopulate);
// Export the Mongoose model
module.exports = mongoose.model('${CAMEL_CASE}', ${CAMEL_CASE}Schema);

end

############################
# Generate controller file #
############################
cat > "$BASE_PATH/app/modules/${DASH_CASE}/${CONTROLLER_FILE}/" << end
import ${CAMEL_CASE}Model from './$DASH_CASE.model';
import ${CAMEL_CASE}Service from './$DASH_CASE.service';
import UtilsProvider from '../../providers/utils.provider'; // Need to change

async function create$CAMEL_CASE(req, res) {
    const validation = validate(req.body);
    if (!validation.success) {
        return res.json(validation);
    }
    try {
        const result = await ${CAMEL_CASE}Service.create$CAMEL_CASE(req.body);
        return res.json({
            success: true,
            ${OBJECT_CASE}: result
        })
    } catch (err) {
        return res.json({
            success: false,
            error: error.message
        })
    }
}

async function update$CAMEL_CASE(req, res) {
    if (!req.params.id) {
        return res.json({
            success: false,
            message: 'id is mandatory in url',
        })
    }
    const validation = validate(req.body);
    if (!validation.success) {
        return res.json(validation);
    }
    try {
        const ${OBJECT_CASE} = await ${CAMEL_CASE}Service.findById(req.params.id);
        if (!${OBJECT_CASE}) {
            return res.json({
                success: false,
                message: 'Invalid id',
            });
        }
        const result = await ${CAMEL_CASE}Service.update$CAMEL_CASE(req.params.id, req.body);
        return res.json({
            success: true,
            ${OBJECT_CASE}: result
        })
    } catch (err) {
        return res.json({
            success: false,
            error: error.message
        })
    }
}
async function get${CAMEL_CASE}(req, res) {
    const result = await ${CAMEL_CASE}Service.find${CAMEL_CASE}(req.body.filter, req.body.select, req.body.skip, req.body.limit);
    return res.json(result);
}


async function get${CAMEL_CASE}ByCampus(req, res) {
    const result = await ${CAMEL_CASE}Service.find${CAMEL_CASE}({campusId: req.body.campusId}, req.body.select, req.body.skip, req.body.limit);
    return res.json(result);
}

async function get${CAMEL_CASE}ByApartment(req, res) {
    const result = await ${CAMEL_CASE}Service.find${CAMEL_CASE}({campusApartmentDetailsId: req.body.campusApartmentDetailsId}, req.body.select, req.body.skip, req.body.limit);
    return res.json(result);
}

async function get${CAMEL_CASE}ById(req, res) {
    if (!req.params.id) {
        return res.json({
            success: false,
            message: 'id is mandatory in url',
        })
    }
    const result = await ${CAMEL_CASE}Service.find${CAMEL_CASE}ById(req.params.id);
    return res.json(result);
}


function validate($OBJECT_CASE) {
    if (!$OBJECT_CASE) {
        return {
            success: false,
            message: 'null object found',
        }
    }
    if (!$OBJECT_CASE.something) {
        return {
            success: false,
            message: 'something is required',
        }
    }
    return {
        success: true,
    }
}
end

##########################
#  Generate service file #
##########################
cat > "$BASE_PATH/app/modules/${DASH_CASE}/$SERVICE_FILE" << end
import ${CAMEL_CASE}Model from './$DASH_CASE.model';


function create$CAMEL_CASE($OBJECT_CASE) {
  const created$CAMEL_CASE = new ${CAMEL_CASE}Model($OBJECT_CASE)
  return created$CAMEL_CASE.save();
}

/**
 * [update${CAMEL_CASE} Update the CAMEL_CASE]
 */
function update${CAMEL_CASE}(${OBJECT_CASE}Id, $OBJECT_CASE) {
  const query = ${CAMEL_CASE}Model.findByIdAndUpdate(${OBJECT_CASE}Id, $OBJECT_CASE);
  return query.exec();
}


/**
 * [find${CAMEL_CASE} Find the $CAMEL_CASE]
 */
function find${CAMEL_CASE}(filter, select, skip, limit) {
  const query = ${CAMEL_CASE}Model.find(filter);
  return query
            .skip(skip)
            .select(select)
            .limit(limit)
            .lean(true)
            .exec();
}

/**
 * [find${CAMEL_CASE}ById Find the ${CAMEL_CASEB}yId]
 */
function find${CAMEL_CASE}ById(id) {
  const query = ${CAMEL_CASE}Model.findById(id);
  return query.lean(true).exec();
}

module.exports = {
    find${CAMEL_CASE}ById,
    find${CAMEL_CASE},
    update${CAMEL_CASE},
    create$CAMEL_CASE,
}
end



## Router file to be updated with ##
## Model provider file to be updated with ##
## Test file for the module ##