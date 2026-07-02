<?php

namespace App\Dto;

use Symfony\Component\Validator\Constraints as Assert;

class PricesFloatDto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(0.01)]
        public ?float $priceA = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(0.01)]
        public ?float $priceB = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(0.01)]
        public ?float $priceC = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(0.01)]
        public ?float $priceD = null,
    ) {
    }
}
