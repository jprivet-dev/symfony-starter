<?php

namespace App\Dto;

use BcMath\Number;
use Symfony\Component\Validator\Constraints as Assert;

class PriceV2Dto
{
    public function __construct(
        #[Assert\NotNull]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceA = null,

        #[Assert\NotNull]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceB = null,

        #[Assert\NotNull]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceC = null,

        #[Assert\NotNull]
        #[Assert\Range(min: 0, max: 1000)]
        public ?Number $priceD = null,
    ) {
    }
}
