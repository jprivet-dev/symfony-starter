<?php

namespace App\Dto;

use BcMath\Number;
use Symfony\Component\Validator\Constraints as Assert;

class PriceV0Dto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceA = null,
    ) {
    }
}
