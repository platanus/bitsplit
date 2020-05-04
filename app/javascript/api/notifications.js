import { authedAxios } from '../helpers'

const markAsSeenApi = notificationToken => {
  console.log(notificationToken)
  return authedAxios.patch('/api/v1/firebase', {
    notification_token: notificationToken
  })
}

export { markAsSeenApi }