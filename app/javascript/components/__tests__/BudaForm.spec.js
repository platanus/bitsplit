import { shallowMount } from '@vue/test-utils'
import BudaForm from '../BudaForm'

describe('BudaForm', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(BudaForm)
    expect(wrapper).toMatchSnapshot()
  })
})
