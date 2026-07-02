<?php

namespace App\Dto;

use BcMath\Number;
use Symfony\Component\Validator\Constraints as Assert;

class PriceFloatDto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(0.01)]
        public ?float $price = null,
    ) {
    }
}
