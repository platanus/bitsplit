import { shallowMount } from '@vue/test-utils';
import Landing from '../Landing';

describe('Landing', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(Landing);
    expect(wrapper).toMatchSnapshot();
  });
});
