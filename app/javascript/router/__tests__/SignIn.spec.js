import { shallowMount } from '@vue/test-utils'
import SignIn from '../SignIn'

describe('SignIn', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(SignIn)
    expect(wrapper).toMatchSnapshot()
  })
})
