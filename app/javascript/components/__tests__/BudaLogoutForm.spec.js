import { shallowMount } from '@vue/test-utils'
import BudaLogoutForm from '../BudaLogoutForm'

describe('BudaLogoutForm', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(BudaLogoutForm)
    expect(wrapper).toMatchSnapshot()
  })
})
