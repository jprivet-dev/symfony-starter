<?php

namespace App\Dto;

use BcMath\Number;
use Symfony\Component\Validator\Constraints as Assert;

class PriceV1Dto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?string $priceA = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?string $priceB = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(0.01)]
        public ?string $priceC = null,

        #[Assert\NotBlank]
        #[Assert\Range(min: 0, max: 1000)]
        public ?string $priceD = null,
    ) {
    }
}
