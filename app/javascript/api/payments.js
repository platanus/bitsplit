import { authedAxios } from '../helpers';

const getPaymentsApi = () => authedAxios.get('/api/v1/payments/');

export { getPaymentsApi };
