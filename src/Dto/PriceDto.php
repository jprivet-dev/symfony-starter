<?php

namespace App\Dto;

use Symfony\Component\Validator\Constraints as Assert;

class PriceDto
{
    public function __construct(
        #[Assert\NotNull]
        #[Assert\GreaterThanOrEqual(new \BcMath\Number('0.01'))]
        public ?\BcMath\Number $priceA = null,

        #[Assert\NotNull]
        #[Assert\GreaterThanOrEqual('0.01')]
        public ?\BcMath\Number $priceB = null,

        #[Assert\NotNull]
        #[Assert\GreaterThanOrEqual(0.01)]
        public ?\BcMath\Number $priceC = null,

        #[Assert\NotNull]
        #[Assert\Range(min: 0, max: 1000)]
        public ?\BcMath\Number $priceD = null,
    ) {
    }
}
