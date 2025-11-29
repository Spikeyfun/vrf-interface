module supra_addr::supra_vrf {

    use std::string::String;
    use supra_addr::deposit::SupraVRFPermit;

    native public entry fun update_public_key(owner_signer: &signer, public_key: vector<u8>);

    native public fun rng_request_v2<T>(
        _permit_cap: &SupraVRFPermit<T>,
        callback_function: String,
        rng_count: u8,
        client_seed: u64,
        num_confirmations: u64,
    ): u64;

    #[deprecated]
    native public fun rng_request(
        sender: &signer,
        callback_address: address,
        callback_module: String,
        callback_function: String,
        rng_count: u8,
        client_seed: u64,
        num_confirmations: u64,
    ): u64;

    #[deprecated]
    native public fun rng_request_from_contract(
        _sender: &signer,
        _callback_address: address,
        _callback_module: String,
        _callback_function: String,
        _rng_count: u8,
        _client_seed: u64,
        _num_confirmations: u64,
    ): u64;

    native public fun verify_callback(
        nonce: u64,
        message: vector<u8>,
        signature: vector<u8>,
        caller_address: address,
        rng_count: u8,
        client_seed: u64,
    ): vector<u256>;

    native public fun collect_tx_fee_from_client(
        sender: &signer,
        client_address: address,
        amount: u64,
        nonce: u64
    );

    native public fun collect_tx_fee_from_client_v2<T>(
        sender: &signer,
        amount: u64,
        nonce: u64
    );

    #[view] native public fun get_dkg_object_address(): address;
    #[view] native public fun get_config_object_address(): address;
    #[view] native public fun get_nonce_processed_object_address(): address;
}
