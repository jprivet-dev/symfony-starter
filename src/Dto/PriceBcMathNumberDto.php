<?php

namespace App\Dto;

use BcMath\Number;
use Symfony\Component\Validator\Constraints as Assert;

class PriceBcMathNumberDto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceA = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceB = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceC = null,

        #[Assert\NotBlank]
        #[Assert\GreaterThanOrEqual(new Number('0.01'))]
        public ?Number $priceD = null,
    ) {
    }
}
