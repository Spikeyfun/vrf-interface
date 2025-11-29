module supra_addr::deposit {

    use std::string::String;
    use std::vector;

    // ============================================================================
    // Estructuras (Activas y Deprecated)
    // ============================================================================

    /// Capability struct for VRF module permissions
    struct SupraVRFPermit<phantom T> has store {}

    /// Client's module balance information return struct
    struct ClientModuleInfo has drop, copy {
        module_type_info: String,
        max_callback_txn_fee: u64,
        min_balance_limit: u64,
        balance: u64,
        enabled: bool,
        current_grant: u64
    }

    /// Client fund information return struct (V2)
    struct ClientFundInfo has drop, copy {
        client_address: address,
        min_balance_limit: u64,
        balance: u64,
        current_grant: u64,
        max_txn_fee: u64
    }

    /// [DEPRECATED] Subscription period information
    struct SubscriptionPeriod has store, drop, copy {
        start_date: u64,
        end_date: u64,
    }

    /// [DEPRECATED] Client balance information return struct
    struct ClientBalanceInfo has drop, copy {
        client_address: address,
        min_balance_limit: u64,
        balance: u64
    }

    // ============================================================================
    // Funciones de Inicialización y Admin (V2 / Activas)
    // ============================================================================

    native public entry fun reinitialize_module(owner: &signer, min_request_count: u64, default_supra_grant: u64);
    native public entry fun migrate_to_multisig(owner_signer: &signer, multisig_address: address);
    native public entry fun set_min_balance_limit_supra(sender: &signer, min_balance_limit_supra: u64);
    native public entry fun set_cold_wallet(sender: &signer, new_supra_multisig_vrf: address);
    native public entry fun set_default_supra_amount(sender: &signer, default_grant: u64);
    native public entry fun set_min_request_count(sender: &signer, min_request_count: u64);
    native public entry fun set_contract_disabling_v2(sender: &signer, pause: bool);
    native public entry fun claim_free_node_expenses_v2(sender: &signer, amount: u64);
    native entry fun increase_client_grant(admin: &signer, client_address: address, amount: u64);
    native public entry fun disable_all_client_modules(sender: &signer, client_address: address);

    // ============================================================================
    // Funciones de Cliente (V2 / Activas)
    // ============================================================================

    native public entry fun whitelist_client_address(client: &signer, max_txn_fee: u64);
    native public fun init_vrf_module<T>(client: &signer): SupraVRFPermit<T>;
    native public entry fun enable_module<T>(client: &signer);
    native public entry fun disable_module<T>(client: &signer);
    native public fun remove_module<T>(permit_cap: SupraVRFPermit<T>);
    native entry public fun update_max_txn_fee(user: &signer, max_txn_fee: u64);
    native public entry fun update_max_callback_txn_fee<T>(client: &signer, max_callback_txn_fee: u64);
    native public entry fun deposit_fund_v2(sender: &signer, client_address: address, deposit_amount: u64);
    native public entry fun withdraw_fund(sender: &signer, withdraw_amount: u64);

    // ============================================================================
    // Funciones Friend (Cobro de fondos)
    // ============================================================================
    
    native public(friend) fun collect_fund(client_address: address, withdraw_amount: u64, nonce: u64);
    native public(friend) fun collect_fund_v2<T>(withdraw_amount: u64, nonce: u64);
    native public(friend) fun ensure_contract_enabled(deposit_management_addr: address);

    // ============================================================================
    // Funciones de Lectura (V2 / Activas)
    // ============================================================================

    #[view] native public fun get_deposit_management_object_address(): address;
    #[view] native public fun get_balance_object_address(): address;
    #[view] native public fun is_module_enabled<T>(): bool;
    #[view] native public fun is_contract_paused(): bool;
    #[view] native public fun min_request_count(): u64;
    #[view] native public fun default_supra_grant(): u64;
    #[view] native public fun is_client_whitelisted_v2(client_address: address): bool;
    #[view] native public fun has_minimum_balance_reached_v2(client_address: address): bool;
    #[view] native public fun check_client_fund(client_address: address): u64;
    #[view] native public fun get_client_remaining_grant(client_address: address): u64;
    #[view] native public fun get_client_total_grant(client_address: address): u64;
    #[view] native public fun check_min_balance_supra_v2(): u64;
    #[view] native public fun check_min_balance_client_v2(client_address: address): u64;
    #[view] native public fun check_max_txn_fee_client_v2(client_address: address): u64;
    #[view] native public fun check_effective_balance_v2(client_address: address): u64;
    #[view] native public fun get_balance_of_client_v2(addresses: vector<address>): vector<ClientFundInfo>;
    #[view] native public fun get_module_info<T>(): ClientModuleInfo;
    #[view] native public fun get_client_modules_info(client_address: address): vector<ClientModuleInfo>;

    // ============================================================================
    // ============================================================================
    // SECCIÓN DEPRECATED (V1) - Incluidas para compatibilidad total
    // ============================================================================
    // ============================================================================

    // Funciones Entry / Públicas Deprecated
    native public entry fun set_contract_disabling(sender: &signer, pause: bool);
    native public entry fun deposit_fund(sender: &signer, deposit_amount: u64);
    
    #[deprecated] native public entry fun add_client_address(sender: &signer, client_address: address);
    #[deprecated] native public entry fun add_client_address_with_subscription(_sender: &signer, _client_address: address, _subscription_duration: u64);
    #[deprecated] native entry fun migrate_client_contracts_object(_sender: &signer);
    #[deprecated] native public entry fun claim_free_node_expenses(_sender: &signer, _receiver_address: address, _amount: u64);
    #[deprecated] native public entry fun remove_all_client_contracts(_sender: &signer, _client_address: address);
    #[deprecated] native public entry fun update_client_subscription(_sender: &signer, _client_address: address, _new_end_time: u64);
    #[deprecated] native public entry fun client_setting_minimum_balance(_sender: &signer, _min_balance_limit_client: u64);
    #[deprecated] native public entry fun add_contract_to_whitelist(_sender: &signer, _contract_address: address);
    #[deprecated] native public entry fun remove_contract_from_whitelist(_sender: &signer, _contract_address: address);
    #[deprecated] native public entry fun remove_client_address(_sender: &signer, _client_address: address, _client_transfer: bool);

    // Funciones View Deprecated
    #[deprecated] #[view] native public fun get_client_contracts_object_address(): address;
    #[deprecated] #[view] native public fun get_contract_owner_address(_contract: address): address;
    #[deprecated] #[view] native public fun is_contract_eligible(client_address: address, contract_address: address): bool;
    #[deprecated] #[view] native public fun is_client_whitelisted(client_address: address): bool;
    #[deprecated] #[view] native public fun has_minimum_balance_reached(client_address: address): bool;
    #[deprecated] #[view] native public fun check_min_balance(client_address: address): u64;
    #[deprecated] #[view] native public fun check_min_balance_supra(): u64;
    #[deprecated] #[view] native public fun check_min_balance_client(client_address: address): u64;
    #[deprecated] #[view] native public fun check_effective_balance(client_address: address): u64;
    #[deprecated] #[view] native public fun get_clients_contract(client_address: address): vector<address>;
    #[deprecated] #[view] native public fun get_subscription_by_client(client_address: address): SubscriptionPeriod;
    #[deprecated] #[view] native public fun get_balance_of_client(addresses: vector<address>): vector<ClientBalanceInfo>;
}
