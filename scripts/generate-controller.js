const st = `type Query {
    mappedContact(id: ID): MappedContact
    mappedContactsCount(supporterInboxItemId: String!): MappedContactGroupCount
    approvedContactsListWithCount(input: MappedContactQueryInput): MappedContactList
    rejectedContactsListWithCount(input: MappedContactQueryInput): MappedContactList
}

type Mutation {
    approveContacts(mappedContactIds: [String]): [String]
    approveAllRejectedContacts(input: MappedContactActionInput): Boolean
    rejectContacts(mappedContactIds:[String]): [String]
    rejectAllApprovedContacts(input: MappedContactActionInput): Boolean
    deleteAmbiguousContacts(mappedContactIds: [String]): [String]
    deleteAllAmbiguousContacts(input: MappedContactActionInput): [String]
    approveLowScoreContact(mappedContactId: String): String
}`

const found = st.split("\n")
let mode = null
let Query = ``
let Mutation = ``
let Service = ``
for (let i=0; i< found.length; i++) {
  if (mode === "Query") {
    let queryName = found[i];
    if (queryName.includes("(")) {

    }
  }
  if (found[i].replace(" ", "") === "typeQuery{") {
    mode = 'Query'
  }
}