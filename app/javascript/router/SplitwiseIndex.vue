<template>
  <div class="flex justify-center">
    <div>
      <div class="flex text-grey-darker mb-2 px-40">
        <span class="text-black text-xl leading-none mb-10 mt-4 font-bold"
          >Deudas de Splitwise
        </span>
      </div>
      <div class="mt-10" v-if="getSplitwiseDebtsLoading">
        <spinner />
      </div>
      <div v-else class="rounded-md">
        <div v-if="splitwiseSignedIn">
          <div v-if="userSplitwiseDebts.singleDebts">
            <div class="text-grey-darker mb-4">
              <span
                class="text-blue-800 text-lg leading-none mb-4 mt-4 font-bold"
                >Deudas Individuales</span
              >
            </div>
            <div>
              <div
                v-for="(single_debt,
                index) in userSplitwiseDebts.singleDebts.friendsToUser
                  .concat(userSplitwiseDebts.singleDebts.userToFriends)
                  .slice()
                  .reverse()"
                class="flex items-center bg-white rounded shadow-md p-1 mb-2"
                :key="index"
              >
                <div class="flex-column content-center ml-8">
                  <img
                    :src="single_debt.picture"
                    class="rounded-full border-solid border-white border-2 mt-3 w-16 ml-2 mr-6 mb-3"
                  />
                </div>
                <div class="flex-column content-center">
                  <div>
                    <span
                      class="text-xs leading-5 font-semibold rounded-full"
                      :class="[
                        single_debt.type ? 'text-green-800' : 'text-red-800',
                      ]"
                    >
                      {{
                        (single_debt.first_name + ' ' + single_debt.last_name)
                          | removeNull
                      }}
                    </span>
                  </div>
                  <div>
                    <span v-if="single_debt.type">
                      Te deben ({{ single_debt.currency_code }})
                      {{ single_debt.amount }}
                    </span>
                    <span v-else>
                      Debes ({{ single_debt.currency_code }})
                      {{ single_debt.amount }}
                    </span>
                  </div>
                </div>
                <div
                  v-if="
                    supportedCurrencies.includes(single_debt.currency_code) &&
                    !single_debt.type
                  "
                  class="flex-column content-center bg-indigo-800 mr-8 ml-auto"
                >
                  <linkButton
                    classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
                    route="splitwisepayment"
                    :payment-data="{
                      group_id: 0,
                      to_user_id: single_debt.id,
                      first_name: single_debt.first_name,
                      last_name: single_debt.last_name,
                      email: single_debt.email,
                      amount: single_debt.amount,
                      currency_code: single_debt.currency_code.toLowerCase(),
                    }"
                    :field-disabled="false"
                  >
                    Pagar
                  </linkButton>
                </div>
              </div>
            </div>
          </div>
          <div v-if="userSplitwiseDebts.groupDebts.length !== 0">
            <div class="text-grey-darker">
              <span class="flex font-bold text-lg align-top text-blue-800 my-6"
                >Deudas grupales</span
              >
            </div>
            <table class="table-auto custom-table">
              <tbody class="space-y-6">
                <tr
                  v-for="(group,
                  index) in userSplitwiseDebts.groupDebts.slice().reverse()"
                  class="border-t-2"
                  :key="index"
                >
                  <td class="flex h-full pb-6">
                    <div class="text-grey-darker mr-6">
                      <span
                        class="text-blue-800 text-lg leading-none mb-4 mt-4 font-bold"
                        >{{ group.group_name }}</span
                      >
                    </div>
                  </td>
                  <td>
                    <div>
                      <div
                        v-for="(group_debt,
                        index) in group.friendsToUser
                          .concat(group.userToFriends)
                          .slice()
                          .reverse()"
                        class="flex items-center bg-white rounded shadow-md p-1 mb-2"
                        :key="index"
                      >
                        <div class="flex-column content-center ml-8">
                          <img
                            :src="group_debt.picture"
                            class="rounded-full border-solid border-white border-2 mt-3 w-16 ml-2 mr-6 mb-3"
                          />
                        </div>
                        <div class="content-center mr-24">
                          <div>
                            <span
                              class="text-xs leading-5 font-semibold rounded-full mr-20"
                              :class="[
                                group_debt.type
                                  ? 'text-green-800'
                                  : 'text-red-800',
                              ]"
                            >
                              {{
                                (group_debt.first_name +
                                  ' ' +
                                  group_debt.last_name)
                                  | removeNull
                              }}
                            </span>
                          </div>
                          <div>
                            <span v-if="group_debt.type">
                              Te deben ({{ group_debt.currency_code }})
                              {{ group_debt.amount }}
                            </span>
                            <span v-else>
                              Debes ({{ group_debt.currency_code }})
                              {{ group_debt.amount }}
                            </span>
                          </div>
                        </div>
                        <div
                          v-if="
                            supportedCurrencies.includes(
                              group_debt.currency_code
                            ) && !group_debt.type
                          "
                          class="flex content-center bg-indigo-800 mr-8 ml-auto"
                        >
                          <linkButton
                            classmod="bg-blue-500 hover:bg-blue-700 my-3 md:my-0"
                            route="splitwisepayment"
                            :payment-data="{
                              group_id: group.group_id,
                              to_user_id: group_debt.id,
                              first_name: group_debt.first_name,
                              last_name: group_debt.last_name,
                              email: group_debt.email,
                              amount: group_debt.amount,
                              currency_code: group_debt.currency_code.toLowerCase(),
                            }"
                            :field-disabled="false"
                          >
                            Pagar
                          </linkButton>
                        </div>
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="flex-column" v-else>
          <p class="text-center text-5xl font-bold mb-4">
            No hay deudas para mostrar
          </p>
          <div class="text-center mb-10 mr-14">
            <SubmitButton @do-click="openSplitwiseUrl()">
              Sincronizar tu cuenta de Splitwise
            </SubmitButton>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import linkButton from '../components/LinkButton';
import spinner from '../components/Spinner';
import SubmitButton from '../components/SubmitButton';

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home',
      debtsColumns: ['', '', 'Nombre', 'Monto', ''],
      supportedCurrencies: ['BTC', 'CLP'],
    };
  },
  created() {
    this.getSplitwiseDebts();
  },
  components: {
    linkButton,
    spinner,
    SubmitButton,
  },
  methods: {
    ...mapActions('splitwiseDebts', ['getSplitwiseDebts']),
    ...mapActions('user', ['getSplitwiseUrl']),
    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
    },
    openSplitwiseUrl() {
      this.getSplitwiseUrl()
        .then(res => {
          window.location.href = res.authorize_url;
        })
        .catch(err => {
          console.error(err);
        });
    },
  },
  computed: {
    ...mapState('user', ['currentUser']),
    ...mapState('splitwiseDebts', [
      'getSplitwiseDebtsLoading',
      'userSplitwiseDebts',
    ]),
    ...mapGetters('user', ['splitwiseSignedIn']),
  },
  filters: {
    removeNull(value) {
      if (!value) return '';
      // eslint-disable-next-line no-param-reassign
      value = value.replace('null', '');

      return value;
    },
  },
};
</script>

<style>
.custom-table {
  border-collapse: separate;
  border-spacing: 0 1em;
}
</style>
