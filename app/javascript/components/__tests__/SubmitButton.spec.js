import { shallowMount } from '@vue/test-utils';
import SubmitButton from '../SubmitButton';

describe('SubmitButton', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(SubmitButton, {
      propsData: { fieldPlaceholder: 'Button' },
    });
    expect(wrapper).toMatchSnapshot();
  });
});
