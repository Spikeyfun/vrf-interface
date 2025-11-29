module supra_addr::supra_vrf {
    
    use std::string::String;
    use supra_addr::deposit::SupraVRFPermit;

    // ============================================================================
    // Admin Configuration Functions
    // ============================================================================

    /// Only the Owner can perform this action.
    /// Updates the DKG public key.
    native public entry fun update_public_key(owner_signer: &signer, public_key: vector<u8>);

    // ============================================================================
    // VRF Request Functions (Public / Entry)
    // ============================================================================

    /// (Deprecated) Public function to request random number generation.
    native public fun rng_request(
        sender: &signer,
        callback_address: address,
        callback_module: String,
        callback_function: String,
        rng_count: u8,
        client_seed: u64,
        num_confirmations: u64,
    ): u64;

    /// (Deprecated) Public function specifically for dice contracts to request RNG.
    native public fun rng_request_from_contract(
        _sender: &signer,
        _callback_address: address,
        _callback_module: String,
        _callback_function: String,
        _rng_count: u8,
        _client_seed: u64,
        _num_confirmations: u64,
    ): u64;

    /// Public function to request random number generation (V2).
    /// Requires a `SupraVRFPermit` obtained from `deposit::init_vrf_module`.
    native public fun rng_request_v2<T>(
        _permit_cap: &SupraVRFPermit<T>,
        callback_function: String,
        rng_count: u8,
        client_seed: u64,
        num_confirmations: u64,
    ): u64;

    // ============================================================================
    // Callback Verification Functions
    // ============================================================================

    /// Public function to verify callback parameters and signature.
    /// Returns the vector of generated random numbers.
    native public fun verify_callback(
        nonce: u64,
        message: vector<u8>,
        signature: vector<u8>,
        caller_address: address,
        rng_count: u8,
        client_seed: u64,
    ): vector<u256>;

    // ============================================================================
    // Fee Collection Functions
    // ============================================================================

    /// Collects VRF response transaction fees from the clients wallet (V1).
    /// Only callable by whitelisted free-nodes.
    native public fun collect_tx_fee_from_client(
        sender: &signer,
        client_address: address,
        amount: u64,
        nonce: u64
    );

    /// Collects VRF response transaction fees from the clients wallet (V2).
    /// Only callable by whitelisted free-nodes.
    native public fun collect_tx_fee_from_client_v2<T>(
        sender: &signer,
        amount: u64,
        nonce: u64
    );

    // ============================================================================
    // View Functions
    // ============================================================================

    #[view]
    /// Returns the DKG object address.
    native public fun get_dkg_object_address(): address;

    #[view]
    /// Returns the Config object address.
    native public fun get_config_object_address(): address;

    #[view]
    /// Returns the Processed Nonce object address.
    native public fun get_nonce_processed_object_address(): address;
}
