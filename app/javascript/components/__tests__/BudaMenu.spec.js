import { shallowMount } from '@vue/test-utils';
import BudaMenu from '../buda/BudaMenu';

describe('BudaMenu', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(BudaMenu);
    expect(wrapper).toMatchSnapshot();
  });
});
