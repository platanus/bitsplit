import { shallowMount } from '@vue/test-utils'
import PasswordInput from '../PasswordInput'

describe('PasswordInput', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(PasswordInput, {
      propsData: {
        fieldName: 'password',
        fieldId: 'password'
      }
    })
    expect(wrapper).toMatchSnapshot()
  })
})
