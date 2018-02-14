# Sample usage
# ./generate.sh SendSms sendSms

echo "$1" "$2"
BASE_PATH=`pwd`
DASH_CASE=$(perl -ne 'print lc(join("-", split(/(?=[A-Z])/)))' <<< $1 )
MODEL_FILE="$DASH_CASE.model.ts"
REDUCER_FILE="$DASH_CASE.reducer.ts"
ACTION_FILE="$DASH_CASE.action.ts"
EFFECT_FILE="$DASH_CASE.effect.ts"
PROVIDER_FILE="$DASH_CASE.ts"
UPPER_CASE=$( awk '{print toupper($0)}' <<< $1 )
CAMEL_CASE=$1
OBJECT_CASE=$2
mkdir ./src/providers/${DASH_CASE}

#########################
#  Generate model file  #
#########################
cat > "$BASE_PATH/src/models/$MODEL_FILE" << end
export interface ${CAMEL_CASE}State {
    loading: boolean;
    error: any;
}
end

###################################
#  Append model file in index.ts  #
###################################
# cat "export * from './${MODEL_FILE}' " >> "$BASE_PATH/src/models/index.ts"

#########################
# Generate reducer file #
#########################
cat > "$BASE_PATH/src/store/reducers/$REDUCER_FILE" << end
import { Action, createSelector } from '@ngrx/store';
import { ${CAMEL_CASE}State } from '../../models/index';

export const InitialState: ${CAMEL_CASE}State = {
    loading: false,
    error: null
};

// $CAMEL_CASEData state reducer function
export const ${CAMEL_CASE}Reducer = (state: ${CAMEL_CASE}State = InitialState, action: ${CAMEL_CASE}Actions) => {
    switch (action.type) {
        case ${CAMEL_CASE}ActionTypes.LOAD_${UPPER_CASE}_DATA
            return {
                ...state, ...action['payload']
            }
        case ${CAMEL_CASE}ActionTypes.LOAD_${UPPER_CASE}_DATA_SUCCESS:
            return {
                ...state, ...action['payload']
            }
        case ${CAMEL_CASE}ActionTypes.LOAD_${UPPER_CASE}_DATA_FAILED:
            return {
                ...state, ...action['payload']
            }
    }
}
export const get${CAMEL_CASE} = (state: any) => state;
export const get${CAMEL_CASE}Loading = (state: any) => state.loading;
export const get${CAMEL_CASE}Error = (state: any) => state.error;
end

#########################
#  Generate action file #
#########################
cat > "$BASE_PATH/src/store/actions/$ACTION_FILE" << end
import { Action, ActionReducer, State } from '@ngrx/store';
export const ${CAMEL_CASE}ActionTypes = {
    LOAD_${UPPER_CASE}_DATA: '[$1] Load $1 data',
    LOAD_${UPPER_CASE}_DATA_SUCCESS: '[$1] Load $1 data success',
    LOAD_${UPPER_CASE}_DATA_FAILED: '[$1] Load $1 data failed',
}
export class ${CAMEL_CASE}Action implements Action {
    readonly type = ${CAMEL_CASE}ActionTypes.LOAD_${UPPER_CASE}_DATA;

    constructor(public payload: any) {
        console.log(this.payload, 'Load${CAMEL_CASE}sAction')
    }
}
export class ${CAMEL_CASE}ActionSuccess implements Action {
    readonly type = ${CAMEL_CASE}ActionTypes.LOAD_${UPPER_CASE}_DATA_SUCCESS;

    constructor(public payload: any) {
        console.log(this.payload, 'Load${CAMEL_CASE}ActionSuccess')
    }
}
export class ${CAMEL_CASE}ActionFailed implements Action {
    readonly type = ${CAMEL_CASE}ActionTypes.LOAD_${UPPER_CASE}_DATA_FAILED;

    constructor(public payload: any) {
        console.log(this.payload, 'Load${CAMEL_CASE}ActionFailed')
    }
}
export type ${CAMEL_CASE}Actions = ${CAMEL_CASE}Action | ${CAMEL_CASE}ActionSuccess | ${CAMEL_CASE}ActionFailed;
end


#########################
# Generate effects file #
#########################

cat > "$BASE_PATH/src/store/effects/$EFFECT_FILE" << end
import { Injectable } from '@angular/core';

// import @ngrx
import { Effect, Actions, toPayload } from '@ngrx/effects';
import { Action } from '@ngrx/store';

// import rxjs
import { Observable } from 'rxjs/Observable';
// import models

@Injectable()
export class ${CAMEL_CASE}Effects {
    /**
     * Comments
     */
    @Effect()
    public methodName: Observable<Action> = this.actions
        .ofType(${CAMEL_CASE}ActionTypes.LOAD_${UPPER_CASE}_DATA_SUCCESS)
        .debounceTime(100)
        .map(toPayload)
        .switchMap(payload => {
            return this.${OBJECT_CASE}Service.authenticateByEmailPassword(payload.email, payload.password)
                .map(res => new ${CAMEL_CASE}ActionSucces(res))
                .catch(error => Observable.of(new ${CAMEL_CASE}ActionFailure({ error: error })));
        });

        constructor(private ${OBJECT_CASE}Service: ${CAMEL_CASE}Provider, private actions: Actions) {
        }

}
end


############################
# Generate a provider file #
############################
cat > "$BASE_PATH/src/providers/${DASH_CASE}/${PROVIDER_FILE}" << end
import { Injectable } from '@angular/core';
import 'rxjs/add/operator/map';
import { Observable } from 'rxjs/Observable';
import { MeteorObservable } from '@votercircle/meteor-rxjs';
@Injectable()
export class ${CAMEL_CASE}Provider {

    private _authenticated = false;

    constructor() {
        console.log('Hello UserLoginProvider Provider');
    }
     public methodName(payload: any): Observable<any> {
        return
            MeteorObservable.call('methodName', payload).subscribe(err => {
                if (!err) {
                    observer.next(true);
                    observer.complete();
                } else {
                    observer.error(err);
                }
            });
        })
    }
    public methodName(payload: any): Observable<any> {
        return MeteorObservable.call(payload)
    }
}
end
