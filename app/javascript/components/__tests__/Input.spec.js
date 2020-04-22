import { shallowMount } from '@vue/test-utils'
import Input from '../Input'

describe('Input', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(Input, {
      propsData: {
        fieldName: 'name',
        fieldFor: 'for',
        fieldPlaceholder: 'placeholder',
        fieldId: 'id'
      }
    })
    expect(wrapper).toMatchSnapshot()
  })
})
