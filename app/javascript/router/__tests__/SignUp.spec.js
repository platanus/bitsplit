import { shallowMount } from '@vue/test-utils'
import SignUp from '../SignUp'

describe('SignUp', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(SignUp)
    expect(wrapper).toMatchSnapshot()
  })
})
