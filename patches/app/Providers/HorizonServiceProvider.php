<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Laravel\Horizon\Horizon;

class HorizonServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        Horizon::routeMailNotificationsTo(config('mail.from.address', 'you@example.com'));
        Horizon::routeSlackNotificationsTo(null);
        Horizon::night();
    }
}
