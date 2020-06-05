<template>
  <div>
    <div class="txt-card h-auto px-48">
      <div class="flex md:flex-row-reverse flex-wrap">
        <div class="w-full md:w-3/4 p-4 text-center">
          <div class="text-left pl-4 pt-8 mb-8">
            <span class="text-base text-xl mr-2">{{ currentUser.email }}</span>
          </div>
          <div class="text-left pl-4 pt-3">
            <span class="text-base font-semibold mr-2">
              <b>Wallet actual:</b> {{ currentWallet }}
            </span>

            <button
              class="btn ext-black font-bold p-1 rounded focus:outline-none"
              @click="change()"
            >
              Cambiar Wallet
            </button>
          </div>
        </div>
        <div class="w-full md:w-1/4 p-4 text-center">
          <div class="w-full relative md:w-3/4 text-center mt-8">
            <button class="flex">
              <img
                src="https://t4.ftcdn.net/jpg/00/64/67/63/240_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
                class="rounded-full border-white border-2 w-34 ml-6 mr-6 mb-3"
              />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState, mapGetters, mapActions } from 'vuex';

export default {
  name: 'ProfileSettings',
  data() {
    return {};
  },
  methods: {
    ...mapActions('user', ['changeWallet']),
    change() {
      this.changeWallet(this.currentWallet);
    },
  },
  computed: {
    ...mapState('user', [
      'currentUser',
      'userBalanceCLP',
      'userBalanceBTC',
      'currentWallet',
    ]),
    ...mapGetters('user', ['budaSignedIn', 'splitwiseSignedIn']),
  },
};
</script>
