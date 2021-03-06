API_V1 = {
  swagger: '2.0',
  info: {
    title: 'API V1',
    version: 'v1'
  },
  basePath: '/api/v1',
  definitions: {
    user: USER_SCHEMA,
    users_collection: USERS_COLLECTION_SCHEMA,
    user_resource: USER_RESOURCE_SCHEMA,
  }
}
