import { shallowMount } from '@vue/test-utils';
import app from 'app';

describe('app', () => {
  test('is a Vue instance', () => {
    const wrapper = shallowMount(app, { stubs: ['router-view'] });
    expect(wrapper.isVueInstance()).toBeTruthy();
  });
});
