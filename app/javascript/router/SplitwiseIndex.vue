<template>
  <div class="flex justify-center m-8">
    <div>
      <div class="text-grey-darker mb-6">
        <span class="text-black text-xl leading-none mb-10 mt-4 font-bold"
          >Deudas de Splitwise
        </span>
      </div>
      <div v-if="getSplitwiseDebtsLoading">
        <spinner />
      </div>
      <div v-else class="rounded-md">
        <div
          v-if="userSplitwiseDebts.singleDebts || userSplitwiseDebts.groupDebts"
        >
        
          <div v-if="userSplitwiseDebts.singleDebts">
            <div class="text-grey-darker">
              <span class="text-blue-800 text-lg leading-none mb-4 mt-4 font-bold">Deudas Individuales</span>
            </div>
            <div>
              <div
                v-for="(single_debt,index) in userSplitwiseDebts.singleDebts.friendsToUser
                      .concat(userSplitwiseDebts.singleDebts.userToFriends)
                      .slice()
                      .reverse()
                "
                class="flex items-center"
                :key="index"
              >
                <div class="flex-column content-center">
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
                      ]"                 >
                      {{ single_debt.first_name + ' ' + single_debt.last_name  | removeNull }} 
                    </span>
                  </div>
                  <div>
                    <span
                      v-if="single_debt.type"
                    >
                      Te deben ${{ single_debt.amount }}
                    </span>
                    <span
                      v-else
                    >
                      Debes ${{ single_debt.amount }}
                    </span>
                  </div>
                </div>
                <div 
                  v-if="single_debt.is_payable && !single_debt.type" 
                  class="flex-column content-center bg-indigo-800 ml-auto"
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

          <div v-if="userSplitwiseDebts.groupDebts">
            <div
              v-for="(group,
              index) in userSplitwiseDebts.groupDebts.slice().reverse()"
              class="mb-4"
              :key="index"
            >
              <div class="text-grey-darker">
                <span class="text-blue-800 text-lg leading-none mb-4 mt-4 font-bold">{{ group.group_name }}</span>
              </div>
              <div>
                <div
                  v-for="(group_debt,index) in group.friendsToUser
                      .concat(group.userToFriends)
                      .slice()
                      .reverse()
                  "
                  class="flex items-center"
                  :key="index"
                >
                  <div class="flex-column content-center">
                    <img
                      :src="group_debt.picture"
                      class="rounded-full border-solid border-white border-2 mt-3 w-16 ml-2 mr-6 mb-3"
                    />
                  </div>
                  <div class="flex-column content-center">
                    <div>
                      <span
                        class="text-xs leading-5 font-semibold rounded-full"
                        :class="[
                          group_debt.type ? 'text-green-800' : 'text-red-800',
                        ]"                 >
                        {{ group_debt.first_name + ' ' + group_debt.last_name  | removeNull }} 
                      </span>
                    </div>
                    <div>
                      <span
                        v-if="group_debt.type"
                      >
                        Te deben ${{ group_debt.amount }}
                      </span>
                      <span
                        v-else
                      >
                        Debes ${{ group_debt.amount }}
                      </span>
                    </div>
                  </div>
                  <div 
                    v-if="group_debt.is_payable && !group_debt.type" 
                    class="flex-column content-center bg-indigo-800 ml-auto"
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
            </div>
          </div>
        </div>
        <div v-else>
          <p class="text-5xl font-bold">
            No hay deudas para mostrar
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import linkButton from '../components/LinkButton';
import spinner from '../components/Spinner';

export default {
  name: 'Home',
  data() {
    return {
      routeName: 'home',
      debtsColumns: ['', '', 'Nombre', 'Monto', ''],
    };
  },
  created() {
    this.getSplitwiseDebts();
  },
  components: {
    linkButton,
    spinner,
  },
  methods: {
    ...mapActions('splitwiseDebts', ['getSplitwiseDebts']),
    getDate(date) {
      const d = new Date(date);

      return d.toLocaleString('en-US', { hour12: false });
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
    removeNull: function (value) {
      if (!value) return ''
      value = value.replace('null', '');
      return value
    },
  },
};
</script>

<style></style>
