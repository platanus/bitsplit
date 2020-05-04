import { authedAxios } from '../helpers'

const markAsSeen = notificationToken => {
  return authedAxios.patch('/api/v1/firebase', {
    notification_token: notificationToken
  })
}

export { markAsSeen }
