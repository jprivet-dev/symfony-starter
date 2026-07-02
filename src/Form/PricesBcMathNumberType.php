<?php

namespace App\Form;

use App\Dto\PricesBcMathNumberDto;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PricesBcMathNumberType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('priceA', \BcMathNumberType::class)
            ->add('priceB', \BcMathNumberType::class)
            ->add('priceC', \BcMathNumberType::class)
            ->add('priceD', \BcMathNumberType::class);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PricesBcMathNumberDto::class]);
    }
}
