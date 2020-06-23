import { shallowMount } from '@vue/test-utils';
import BudaAlert from '../buda/BudaAlert';

describe('BudaAlert', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(BudaAlert, {
      stubs: ['router-link'],
    });
    expect(wrapper).toMatchSnapshot();
  });
});
