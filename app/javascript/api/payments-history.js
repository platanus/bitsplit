/* eslint-disable camelcase */
import { authedAxios } from '../helpers';

const getPaymentsApi = () => authedAxios.get('/api/v2/transactions/');

export { getPaymentsApi };
