import { shallowMount } from '@vue/test-utils';
import BudaForm from '../buda/BudaForm';

describe('BudaForm', () => {
  xit('matches snapshot', () => {
    const wrapper = shallowMount(BudaForm);
    expect(wrapper).toMatchSnapshot();
  });
});
