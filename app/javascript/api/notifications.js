import { authedAxios } from '../helpers';

const markAsSeenApi = notificationToken => authedAxios.patch('/api/v1/firebase', {
  // eslint-disable-next-line camelcase
  notification_token: notificationToken,
});

export { markAsSeenApi };
